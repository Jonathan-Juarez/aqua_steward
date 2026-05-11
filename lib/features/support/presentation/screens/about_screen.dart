import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:aqua_steward/main.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String appName = packageInfo.appName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_acerca_de,
      children: [
        // Identidad de la Aplicación
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo_transparente_AquaSteward.png',
                height: 120,
              ),
              AppSizedBox.height12,
              TextFormat(text: appName, context: context, type: "title"),
              TextFormat(
                text: context.l10n.acerca_version(version, buildNumber),
                context: context,
                type: "bodySmall",
              ),
            ],
          ),
        ),

        AppSizedBox.height12,

        // Propósito
        TextFormat(
          text: context.l10n.acerca_proposito_titulo,
          context: context,
          type: "subtitle",
        ),
        ContainerFormat(
          children: [
            TextFormat(
              text: context.l10n.acerca_proposito_desc,
              context: context,
              type: "body",
              alignCenter: true,
            ),
          ],
        ),

        // Créditos y Desarrollo
        TextFormat(
          text: context.l10n.acerca_creditos_titulo,
          context: context,
          type: "subtitle",
        ),
        ContainerFormat(
          children: [
            TextFormat(
              text: context.l10n.acerca_creditos_desarrollado_por,
              context: context,
              type: "body",
            ),
            TextFormat(
              text: "Jonathan Jahaziel Juárez Villatoro",
              context: context,
              type: "bodySecondary",
            ),
            AppSizedBox.height12,
            TextFormat(
              text: context.l10n.acerca_creditos_institucion,
              context: context,
              type: "body",
            ),
            TextFormat(
              text: context.l10n.acerca_creditos_universidad,
              context: context,
              type: "bodySecondary",
              alignCenter: true,
            ),
            AppSizedBox.height12,
            TextFormat(
              text: context.l10n.acerca_creditos_facultad,
              context: context,
              type: "body",
            ),
            TextFormat(
              text: context.l10n.acerca_creditos_facultad_nombre,
              context: context,
              type: "bodySecondary",
              alignCenter: true,
            ),
          ],
        ),

        // Enlaces Legales y de Privacidad
        TextFormat(
          text: context.l10n.acerca_legal_titulo,
          context: context,
          type: "subtitle",
        ),
        ContainerListTile(
          title: context.l10n.acerca_legal_terminos,
          icon: const Icon(Icons.description_outlined),
          onTap: () {
            // Acción para abrir términos
          },
        ),
        AppSizedBox.height12,
        ContainerListTile(
          title: context.l10n.acerca_legal_privacidad,
          icon: AppIcon.lockOutline,
          onTap: () {
            // Acción para abrir privacidad
          },
        ),

        // 5. Licencias de Código Abierto
        TextFormat(
          text: context.l10n.acerca_software_titulo,
          context: context,
          type: "subtitle",
        ),
        ContainerListTile(
          title: context.l10n.acerca_software_licencias,
          icon: AppIcon.code,
          onTap: () => showLicensePage(
            context: context,
            applicationName: appName,
            applicationVersion: version,
            applicationIcon: Image.asset(
              'assets/images/logo_transparente_AquaSteward.png',
              height: 50,
            ),
          ),
        ),
      ],
    );
  }
}
