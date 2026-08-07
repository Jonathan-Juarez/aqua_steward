import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/tech/presentation/providers/tech_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TechDashboardScreen extends StatefulWidget {
  const TechDashboardScreen({super.key});

  @override
  State<TechDashboardScreen> createState() => _TechDashboardScreenState();
}

class _TechDashboardScreenState extends State<TechDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().currentUser?.token ?? "";
      if (token.isNotEmpty) {
        context.read<TechProvider>().loadStats(token: token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.tech_panel_titulo,
      body: Consumer<TechProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingStats && provider.stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = provider.stats;

          return SingleChildScrollView(
            padding: AppPadding.all16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen general de métricas
                TextFormat(
                  text: context.l10n.tech_estado_sistema,
                  type: "subtitle",
                  context: context,
                ),
                AppSizedBox.height8,
                Row(
                  children: [
                    Expanded(
                      child: ContainerFormat(
                        children: [
                          const IconFormat(icon: AppIcon.localDrinkOutlined),
                          AppSizedBox.height8,
                          TextFormat(
                            text: "${stats?.totalDeposits ?? 0}",
                            type: "title",
                            context: context,
                          ),
                          TextFormat(
                            text: context.l10n.tech_depositos,
                            type: "bodySecondary",
                            context: context,
                          ),
                        ],
                      ),
                    ),
                    AppSizedBox.width8,
                    Expanded(
                      child: ContainerFormat(
                        children: [
                          IconFormat(
                            icon: AppIcon.personOutlined(context: context),
                          ),
                          AppSizedBox.height8,
                          TextFormat(
                            text: "${stats?.totalUsers ?? 0}",
                            type: "title",
                            context: context,
                          ),
                          TextFormat(
                            text: context.l10n.tech_usuarios,
                            type: "bodySecondary",
                            context: context,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSizedBox.height12,

                // Desglose de sensores activos
                TextFormat(
                  text: context.l10n.tech_sensores_activos,
                  type: "subtitle",
                  context: context,
                ),
                AppSizedBox.height8,
                ContainerFormat(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormat(
                          text: "Nivel (HC-SR04)",
                          type: "body",
                          context: context,
                        ),
                        TextFormat(
                          text: "${stats?.distanceSensors ?? 0}",
                          type: "subtitle",
                          context: context,
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormat(
                          text: "pH (PH-4502C)",
                          type: "body",
                          context: context,
                        ),
                        TextFormat(
                          text: "${stats?.phSensors ?? 0}",
                          type: "subtitle",
                          context: context,
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormat(
                          text: "Turbidez (TS300B)",
                          type: "body",
                          context: context,
                        ),
                        TextFormat(
                          text: "${stats?.turbiditySensors ?? 0}",
                          type: "subtitle",
                          context: context,
                        ),
                      ],
                    ),
                  ],
                ),

                AppSizedBox.height12,

                // Acceso a Gestión de Usuarios
                ContainerListTile(
                  title: context.l10n.tech_ver_usuarios,
                  icon: AppIcon.groups2Outlined,
                  trailing: AppIcon.arrowRight(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.techUsers),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
