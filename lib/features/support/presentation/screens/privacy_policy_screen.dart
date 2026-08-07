import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/support/presentation/widgets/faq_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ScaffoldMain(
      titleAppBar: l10n.acerca_privacidad_titulo,
      children: [
        AppSizedBox.height12,

        // Introducción
        ContainerFormat(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormat(
                text: l10n.privacidad_introduccion,
                context: context,
                type: "body",
                alignCenter: true,
              ),
            ),
          ],
        ),

        AppSizedBox.height12,

        FAQItem(
          question: l10n.privacidad_sec1_titulo,
          answer: l10n.privacidad_sec1_desc,
        ),
        FAQItem(
          question: l10n.privacidad_sec2_titulo,
          answer: l10n.privacidad_sec2_desc,
        ),
        FAQItem(
          question: l10n.privacidad_sec3_titulo,
          answer: l10n.privacidad_sec3_desc,
          widget: ContainerListTile(
            title: l10n.privacidad_firebase_link,
            icon: AppIcon.launch,
            showTrailing: false,
            onTap: () => launchUrl(
              Uri.parse('https://firebase.google.com/support/privacy'),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ),

        FAQItem(
          question: l10n.privacidad_sec4_titulo,
          answer: l10n.privacidad_sec4_desc,
        ),
        FAQItem(
          question: l10n.privacidad_sec5_titulo,
          answer: l10n.privacidad_sec5_desc,
        ),
        FAQItem(
          question: l10n.privacidad_sec6_titulo,
          answer: l10n.privacidad_sec6_desc,
        ),
        FAQItem(
          question: l10n.privacidad_sec7_titulo,
          answer: l10n.privacidad_sec7_desc,
        ),
        FAQItem(
          question: l10n.privacidad_sec8_titulo,
          answer: l10n.privacidad_sec8_desc,
        ),
      ],
    );
  }
}
