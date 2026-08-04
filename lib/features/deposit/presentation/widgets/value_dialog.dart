import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/extensions/to_clean_string.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ValueDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required double valueDefault,
    required double min,
    required double max,
    required String unit,
    bool allowDecimals = false,
    required ValueChanged<double> onSaved,
  }) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(
      text: valueDefault.toCleanString(),
    );
    final minStr = min.toCleanString();
    final maxStr = max.toCleanString();

    return showDialog(
      context: context,
      builder: (context2) => DialogEmergent(
        title: title,
        formKey: formKey,
        content: Form(
          key: formKey,
          child: TextFieldFormat(
            maxLength: 5,
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              if (!allowDecimals) FilteringTextInputFormatter.digitsOnly,
            ],
            labelText: context2.l10n.comun_rango(minStr, maxStr, unit),
            icon: AppIcon.edit(context: context2),
            validator: (val) => AppValidators.validateNumber(context2, val),
          ),
        ),
        onPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            double limitValue = double.parse(controller.text);
            if (limitValue < min) limitValue = min;
            if (limitValue > max) limitValue = max;
            limitValue = double.parse(limitValue.toCleanString());

            onSaved(limitValue);
            Navigator.pop(context2);
          }
        },
      ),
    );
  }
}
