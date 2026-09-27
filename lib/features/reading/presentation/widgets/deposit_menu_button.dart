import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/permissions/app_permission.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/menu_button_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/dialog_export_csv.dart';
import 'package:aqua_steward/features/team/presentation/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositMenuButton extends StatelessWidget {
  final Map<String, dynamic> depositData;
  final VoidCallback? onDepositDeleted;
  final VoidCallback? onDepositLeft;

  const DepositMenuButton({
    super.key,
    required this.depositData,
    this.onDepositDeleted,
    this.onDepositLeft,
  });

  void _deleteDeposit(BuildContext context, String depositId) async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.currentUser?.token ?? "";

    final result = await context.read<DepositProvider>().deleteDeposit(
      depositId: depositId,
      token: token,
    );
    if (context.mounted) {
      context.processResult(
        result,
        successMessage: context.l10n.snackbar_deposito_eliminado,
      );
      if (result.isSuccess) {
        onDepositDeleted?.call();
      }
    }
  }

  void _leaveDeposit(BuildContext context, String depositId) async {
    final token = context.read<AuthProvider>().currentUser?.token ?? "";
    if (token.isNotEmpty) {
      final result = await context.read<TeamProvider>().leaveDeposit(
        depositId: depositId,
        token: token,
      );
      if (context.mounted) {
        context.processResult(
          result,
          successMessage: context.l10n.snackbar_abandonar_deposito,
        );
        if (result.isSuccess) {
          context.read<DepositProvider>().getDeposits(token: token);
          onDepositLeft?.call();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String role = depositData["role"] ?? "analyst";

    final List<MenuItemModel> menuItems = [
      MenuItemModel(
        value: "members",
        icon: AppIcon.groups2Outlined(context: context),
        text: context.l10n.comun_miembros,
      ),
      if (RolePermissions.has(role, AppPermission.editDeposit)) ...[
        MenuItemModel(
          value: "deposit",
          icon: AppIcon.edit(context: context),
          text: context.l10n.comun_deposito,
        ),
      ],
      MenuItemModel(
        value: "exportCsv",
        icon: AppIcon.csv(context: context),
        text: context.l10n.reporte_exportar_csv,
      ),
      MenuItemModel(
        value: "generatePdf",
        icon: AppIcon.pdf(context: context),
        text: context.l10n.reporte_generar_pdf,
      ),
      if (RolePermissions.has(role, AppPermission.deleteDeposit))
        MenuItemModel(
          value: "delete",
          icon: AppIcon.deleteOutline,
          text: context.l10n.comun_eliminar,
          textStyle: "bodyRed",
        ),
      if (role != "owner")
        MenuItemModel(
          value: "leave",
          icon: AppIcon.deleteOutline,
          text: context.l10n.comun_abandonar,
          textStyle: "bodyRed",
        ),
    ];

    return MenuButtonFormat(
      items: menuItems,
      onSelected: (value) {
        final Map<String, VoidCallback> actions = {
          "exportCsv": () {
            DialogExportCsv.show(context: context, depositData: depositData);
          },
          "generatePdf": () {
            Navigator.pushNamed(
              context,
              AppRouter.generateReports,
              arguments: {"depositData": depositData},
            );
          },
          "members": () {
            Navigator.pushNamed(
              context,
              AppRouter.members,
              arguments: {"depositId": depositData["id"]},
            );
          },
          "deposit": () {
            Navigator.pushNamed(
              context,
              AppRouter.depositScreen,
              arguments: {"depositData": depositData},
            );
          },
          "delete": () {
            showDialog(
              context: context,
              builder: (dialogCtx) => DialogEmergent(
                title: context.l10n.dialogo_eliminar_deposito_titulo,
                content: TextFormat(
                  text: context.l10n.dialogo_eliminar_deposito,
                  context: dialogCtx,
                  type: "body",
                ),
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  _deleteDeposit(context, depositData["id"]);
                },
                formKey: null,
                isLoading: false,
              ),
            );
          },
          "leave": () {
            _leaveDeposit(context, depositData["id"]);
          },
        };

        actions[value]?.call();
      },
    );
  }
}
