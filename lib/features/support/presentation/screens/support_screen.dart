import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/support/presentation/widgets/faq_item.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_soporte,
      children: [
        TextFormat(
          text: context.l10n.soporte_recursos,
          context: context,
          type: "subtitle",
        ),
        ContainerListTile(
          title: context.l10n.soporte_manual,
          icon: AppIcon.manual,
          onTap: () => Navigator.pushNamed(context, AppRouter.userManual),
        ),

        AppSizedBox.height12,

        ContainerListTile(
          title: context.l10n.soporte_acerca_de,
          icon: AppIcon.infoOutlined,
          onTap: () => Navigator.pushNamed(context, AppRouter.about),
        ),
        TextFormat(
          text: context.l10n.soporte_preguntas_frecuentes,
          context: context,
          type: "subtitle",
        ),
        FAQItem(
          question: context.l10n.soporte_faq_p1,
          answer: context.l10n.soporte_faq_r1,
        ),
        FAQItem(
          question: context.l10n.soporte_faq_p2,
          answer: context.l10n.soporte_faq_r2,
        ),
        FAQItem(
          question: context.l10n.soporte_faq_p3,
          answer: context.l10n.soporte_faq_r3,
        ),
        FAQItem(
          question: context.l10n.soporte_faq_p4,
          answer: context.l10n.soporte_faq_r4,
        ),
        FAQItem(
          question: context.l10n.soporte_faq_p5,
          answer: context.l10n.soporte_faq_r5,
        ),
        FAQItem(
          question: context.l10n.soporte_faq_p6,
          answer: context.l10n.soporte_faq_r6,
        ),

        // Tarjeta de Contacto
        ContainerFormat(
          children: [
            const IconFormat(icon: AppIcon.contact),
            TextFormat(
              text: context.l10n.soporte_contacto_ayuda,
              context: context,
              type: "titleSmall",
            ),
            TextFormat(
              text: context.l10n.soporte_contacto_desc,
              context: context,
              type: "body",
              alignCenter: true,
            ),
            ButtonFormat(
              label: context.l10n.soporte_contacto_boton,
              onConfirm: () => Navigator.pushNamed(context, AppRouter.contact),
            ),
          ],
        ),
      ],
    );
  }
}
