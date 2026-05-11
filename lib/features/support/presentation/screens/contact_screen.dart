import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/support/presentation/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  void _sendEmail(BuildContext context, ContactProvider provider) async {
    try {
      await provider.sendEmail(
        subject: provider.subjectController.text,
        message: provider.messageController.text,
      );
    } catch (e) {
      if (context.mounted) {
        SnackBarFormat.show(context, context.l10n.snackbar_error_correo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactProvider>();

    return ScaffoldMain(
      formKey: provider.formKey,
      titleAppBar: context.l10n.titulo_contactar_soporte,
      children: [
        TextFormat(
          text: context.l10n.contacto_formulario,
          context: context,
          type: "subtitle",
        ),
        ContainerFormat(
          children: [
            TextFieldFormat(
              controller: provider.subjectController,
              labelText: context.l10n.contacto_asunto,
              maxLength: 100,
              validator: (val) => AppValidators.validateRequired(context, val),
            ),
            TextFieldFormat(
              controller: provider.messageController,
              labelText: context.l10n.contacto_mensaje,
              maxLength: 1000,
              minLines: 4,
              maxLines: 8,
              validator: (val) => AppValidators.validateRequired(context, val),
            ),
            ButtonFormat(
              formKey: provider.formKey,
              label: context.l10n.contacto_enviar,
              isLoading: provider.isLoading,
              onConfirm: () => _sendEmail(context, provider),
            ),
          ],
        ),
      ],
    );
  }
}
