import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final IconFormat? icon;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.bottom16,
      child: ContainerFormat(
        children: [
          ExpansionTile(
            leading: icon,
            iconColor: Theme.of(context).iconTheme.color,
            title: TextFormat(text: question, context: context, type: "body"),
            children: [
              Padding(
                padding: AppPadding.symmetric0_16,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextFormat(
                    text: answer,
                    context: context,
                    type: "bodySecondary",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
