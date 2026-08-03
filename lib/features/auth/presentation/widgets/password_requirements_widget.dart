import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Renderiza un elemento individual de la lista de requisitos con icono reactivo.
class PasswordRequirementItem extends StatelessWidget {
  final String label;
  final bool isValid;

  const PasswordRequirementItem({
    super.key,
    required this.label,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.symmetric0_8,
      child: Row(
        children: [
          isValid ? AppIcon.checkCircle : AppIcon.cancel,
          AppSizedBox.width8,
          TextFormat(type: "bodySmall", text: label, context: context),
        ],
      ),
    );
  }
}

// Muestra la lista de requisitos de contraseña evaluados dinámicamente.
class PasswordRequirementsWidget extends StatelessWidget {
  final String password;

  const PasswordRequirementsWidget({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PasswordRequirementItem(
          label: "Mínimo 8 caracteres",
          isValid: AppValidators.hasMinLength(password),
        ),
        PasswordRequirementItem(
          label: "Mínimo 1 mayúscula (A-Z)",
          isValid: AppValidators.hasUppercase(password),
        ),
        PasswordRequirementItem(
          label: "Mínimo 1 número (0-9)",
          isValid: AppValidators.hasNumber(password),
        ),
        PasswordRequirementItem(
          label: r'Mínimo 1 especial: !"#$%&/()=?.,@',
          isValid: AppValidators.hasSpecialChar(password),
        ),
      ],
    );
  }
}
