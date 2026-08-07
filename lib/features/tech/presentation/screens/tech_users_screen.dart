import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/list_view_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/tech/presentation/providers/tech_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TechUsersScreen extends StatefulWidget {
  const TechUsersScreen({super.key});

  @override
  State<TechUsersScreen> createState() => _TechUsersScreenState();
}

class _TechUsersScreenState extends State<TechUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().currentUser?.token ?? "";
      if (token.isNotEmpty) {
        context.read<TechProvider>().loadUsers(token: token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TechProvider>();
    final users = provider.users;

    return ScaffoldMain(
      onRefresh: () async {
        final token = context.read<AuthProvider>().currentUser?.token ?? '';
        if (token.isNotEmpty) {
          await provider.loadUsers(token: token);
        }
      },
      titleAppBar: context.l10n.tech_ver_usuarios,
      children: [
        AppSizedBox.height12,
        ListViewFormat(
          isLoading: provider.isLoadingUsers,
          emptyMessage: "No se encontraron usuarios",
          emptyWidget: AppIcon.personOff(context: context),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final isTech = user.global_role == "technician";

            return ContainerListTile(
              title: "${user.name} ${user.lastName}",
              subtitle: user.email,
              icon: AppIcon.personOutlined(
                color: isTech
                    ? AppColor.parameterPH
                    : Theme.of(context).colorScheme.onSurface,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isTech)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.success,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormat(
                        text: "Técnico",
                        type: "bodySmallWhite",
                        context: context,
                      ),
                    ),
                  TextFormat(
                    text: "${user.assignedDepositsCount} dep.",
                    type: "bodySecondary",
                    context: context,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
