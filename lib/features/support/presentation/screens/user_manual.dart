import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/support/presentation/widgets/faq_item.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:flutter/material.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_manual_usuario,
      children: [
        TextFormat(
          text: context.l10n.manual_guia_basica,
          context: context,
          type: "subtitle",
        ),
        FAQItem(
          question: context.l10n.manual_roles_titulo,
          icon: const IconFormat(icon: AppIcon.groups2Outlined),
          answer: context.l10n.manual_roles_desc,
        ),
        FAQItem(
          question: context.l10n.manual_agregar_titulo,
          icon: const IconFormat(icon: AppIcon.waterDamageOutlined),
          answer: context.l10n.manual_agregar_desc,
        ),
        FAQItem(
          question: context.l10n.manual_invitaciones_titulo,
          icon: IconFormat(icon: AppIcon.personAdd()),
          answer: context.l10n.manual_invitaciones_desc,
        ),
        FAQItem(
          question: context.l10n.manual_monitoreo_titulo,
          icon: const IconFormat(icon: AppIcon.lineChart),
          answer: context.l10n.manual_monitoreo_desc,
        ),
      ],
    );
  }
}
