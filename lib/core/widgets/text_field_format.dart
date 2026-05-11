import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldFormat extends StatefulWidget {
  final String? labelText;
  final Icon? icon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int maxLength;
  final int? maxLines;
  final int? minLines;

  const TextFieldFormat({
    this.focusNode,
    super.key,
    this.labelText,
    this.icon,
    this.suffixIcon,
    this.keyboardType,
    this.controller,
    this.validator,
    required this.maxLength,
    this.maxLines = 1,
    this.minLines,
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
        focusNode: widget.focusNode,
        // Salta al siguiente campo cuando se presiona Enter.
        textInputAction: widget.maxLines == 1
            ? TextInputAction.next
            : TextInputAction.newline,
        onChanged: (value) {
          // Salta si tiene un límite de 1 y no es multilínea.
          if (widget.maxLength == 1 && widget.maxLines == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        // Limita la longitud del texto.
        inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
        // Centra el texto si no tiene ícono.
        textAlign: widget.maxLength == 1 ? TextAlign.center : TextAlign.start,

        validator: widget.validator,
        // AutovalidateMode para que valide mientras se escribe.
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: Theme.of(context).textTheme.bodyLarge,
        cursorColor: Theme.of(context).colorScheme.onSurface,
        controller: widget.controller,
        //Censura el texto cuando se tiene un ícono de contraseña.
        obscureText: widget.icon == AppIcon.password
            ? _obscureText ?? true
            : false,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        decoration: InputDecoration(
          prefixIcon: widget.icon,
          label: Text(widget.labelText ?? ""),
          suffixIcon: widget.icon == AppIcon.password
              ? ButtonFormat(
                  type: "icon",
                  onConfirm: () => setState(() {
                    _obscureText = !(_obscureText ?? true);
                  }),
                  icon: Icon(
                    (_obscureText ?? true)
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                )
              : widget.suffixIcon,
        ),
      ),
    );
  }
}
