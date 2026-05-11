import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: AppPadding.all8,
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
        AppSizedBox.height12,
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
        AppSizedBox.height12,
      ],
    );
  }
}
