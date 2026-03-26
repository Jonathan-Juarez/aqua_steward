import 'package:aqua_steward/core/theme/app_padding.dart';
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
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 0.5,
            ),
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: AppPadding.all8,
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
        const SizedBox(height: 20),
        Text('AquaSteward', style: Theme.of(context).textTheme.titleMedium),
        Text(
          "Monitoreo inteligente del agua",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
