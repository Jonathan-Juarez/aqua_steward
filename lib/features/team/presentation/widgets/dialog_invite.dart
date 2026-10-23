import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/menu_button_format.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/team/presentation/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Diálogo modal para invitar a un nuevo miembro al equipo del depósito.
class DialogInvite {
  static void show({required BuildContext context, required String depositId}) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    String selectedRole = "analyst";

    DialogEmergent(
      formKey: formKey,
      title: context.l10n.comun_miembros,
      onPressed: () async {
        final provider = context.read<TeamProvider>();
        final result = await provider.inviteMember(
          depositId: depositId,
          email: emailController.text,
          role: selectedRole,
        );

        if (!context.mounted) return;
        Navigator.pop(context);
        context.processResult(
          result,
          successMessage: context.l10n.snackbar_miembro_invitado_exitoso,
        );
      },
      content: StatefulBuilder(
        builder: (dialogCtx, setDialogState) => Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormat(
                text: dialogCtx.l10n.miembros_ingresar_correo,
                context: dialogCtx,
                type: "bodySecondary",
              ),
              AppSizedBox.height12,
              TextFieldFormat(
                labelText: dialogCtx.l10n.auth_correo,
                icon: AppIcon.emailOutlined,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                maxLength: 40,
                validator: (val) => AppValidators.validateEmail(dialogCtx, val),
              ),
              AppSizedBox.height12,
              // Selector de rol.
              MenuButtonFormat(
                items: [
                  MenuItemModel(
                    value: "analyst",
                    icon: AppIcon.personOutlined(context: dialogCtx),
                    text: dialogCtx.l10n.miembros_rol_analista,
                  ),
                  MenuItemModel(
                    value: "admin",
                    icon: AppIcon.personOutlined(context: dialogCtx),
                    text: dialogCtx.l10n.miembros_rol_admin,
                  ),
                ],
                onSelected: (value) {
                  setDialogState(() => selectedRole = value);
                },
                child: ContainerListTile(
                  title: selectedRole == "admin"
                      ? dialogCtx.l10n.miembros_rol_admin
                      : dialogCtx.l10n.miembros_rol_analista,
                ),
              ),
            ],
          ),
        ),
      ),
    ).show(context);
  }
}
