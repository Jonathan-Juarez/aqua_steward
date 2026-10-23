import "package:aqua_steward/core/extensions/l10n_extensions.dart";
import "package:aqua_steward/core/router/app_router.dart";
import "package:aqua_steward/core/theme/app_icon.dart";
import "package:aqua_steward/core/theme/app_padding.dart";
import "package:aqua_steward/core/theme/app_sizedbox.dart";
import "package:aqua_steward/core/widgets/container_formart.dart";
import "package:aqua_steward/core/widgets/responsive_grid.dart";
import "package:aqua_steward/core/widgets/scaffold_main.dart";
import "package:aqua_steward/core/widgets/text_format.dart";
import "package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart";
import "package:aqua_steward/features/reading/presentation/widgets/deposit_card.dart";
import "package:aqua_steward/features/reading/presentation/widgets/deposit_menu_button.dart";
import "package:aqua_steward/features/reading/presentation/widgets/deposit_skeleton.dart";
import "package:aqua_steward/features/team/presentation/providers/team_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? switchValues;
  const DashboardScreen({super.key, this.switchValues});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  // Mantiene el estado del widget aunque se navegue a otra pantalla.
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Ejecuta la carga inicial de datos cuando el widget se monta en la vista.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final depositProvider = context.read<DepositProvider>();
      if (depositProvider.deposits.isEmpty && !depositProvider.isLoading) {
        depositProvider.getDeposits();
      }
      context.read<TeamProvider>().getInvitations();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldMain(
      onRefresh: () async {
        await context.read<DepositProvider>().getDeposits();
      },
      children: [
        Padding(
          padding: AppPadding.symmetric8_0,
          child: Row(
            children: [
              TextFormat(
                text: context.l10n.titulo_dashboard,
                context: context,
                type: "title",
              ),
            ],
          ),
        ),

        // Nota informativa sobre la interactividad de las tarjetas.
        TextFormat(
          text: context.l10n.dashboard_nota_tarjetas,
          type: "bodySmall",
          context: context,
        ),
        AppSizedBox.height12,

        // Botón para agregar un nuevo depósito en la parte superior derecha.
        ContainerFormat(
          onTap: () => Navigator.pushNamed(context, AppRouter.depositScreen),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon.add,
                TextFormat(
                  text: context.l10n.dashboard_agregar_deposito,
                  context: context,
                  type: "body",
                ),
              ],
            ),
          ],
        ),
        AppSizedBox.height12,

        // Lista de Depósitos mediante Consumer para reaccionar a cambios en el provider.
        Consumer<DepositProvider>(
          builder: (context, provider, _) => ResponsiveGrid(
            isLoading: provider.isLoading && provider.deposits.isEmpty,
            skeletonItem: const DepositSkeleton(),
            items: [
              for (final snapshot in provider.snapshots)
                DepositCard(
                  key: ValueKey(snapshot.deposit.id),
                  snapshot: snapshot,
                  menuWidget: DepositMenuButton(deposit: snapshot.deposit),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
