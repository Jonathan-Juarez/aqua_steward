import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/button_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldFormat extends StatefulWidget {
  final String? labelText;
  final Icon? icon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? maxLength;
  final String? Function(String?)? validator;

  const TextFieldFormat({
    super.key,
    this.labelText,
    this.icon,
    this.keyboardType,
    this.controller,
    this.maxLength,
    this.validator,
  });

  @override
  State<TextFieldFormat> createState() => _TextFieldFormatState();
}

class _TextFieldFormatState extends State<TextFieldFormat> {
  bool? _obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.symmetric8_0,
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(
            widget.icon == null ? 1 : widget.maxLength,
          ),
        ],
        textAlign: widget.icon == null ? TextAlign.center : TextAlign.start,

        validator: widget.validator,
        // AutovalidateMode para que valide mientras se escribe.
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: Theme.of(context).colorScheme.onSurface,
        controller: widget.controller,
        //Censura el texto cuando se tiene un ícono de contraseña.
        obscureText: widget.icon == AppIcon.password
            ? _obscureText ?? true
            : false,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          prefixIcon: widget.icon,
          label: Text(widget.labelText ?? ""),
          suffixIcon: widget.icon == AppIcon.password
              ? ButtonDynamic(
                  onPressed: () => setState(() {
                    _obscureText = !(_obscureText ?? true);
                  }),
                  icon: Icon(
                    (_obscureText ?? true)
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
