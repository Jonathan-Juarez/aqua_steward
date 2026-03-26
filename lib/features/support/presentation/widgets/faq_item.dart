import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:flutter/material.dart';

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.bottom8,
      child: ContainerFormat(
        children: [
          ExpansionTile(
            iconColor: Theme.of(context).iconTheme.color,
            title: Text(
              question,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            children: [
              Padding(
                padding: AppPadding.symmetric0_16,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(answer, style: AppText.bodySecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
