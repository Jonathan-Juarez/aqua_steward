import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Image.asset("assets/images/logo_transparente_AquaSteward.png"),
        ),
        TextFormat(
          text: context.l10n.logo_nombre,
          context: context,
          type: "title",
        ),
        TextFormat(
          text: context.l10n.logo_slogan,
          context: context,
          type: "body",
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
