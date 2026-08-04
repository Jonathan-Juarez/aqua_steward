import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/extensions/to_clean_string.dart';
import 'package:aqua_steward/features/deposit/presentation/widgets/value_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SliderFormat extends StatefulWidget {
  final bool isSingle;
  final double min;
  final double max;
  final int divisions;
  final String labelLimit;
  final String unit;
  final double? valueDefault;
  final RangeValues? rangeValues;
  final bool allowDecimals;
  final ValueChanged<dynamic> onChanged;
  const SliderFormat({
    super.key,
    this.isSingle = false,
    required this.min,
    required this.max,
    required this.divisions,
    required this.labelLimit,
    required this.unit,
    this.valueDefault,
    this.rangeValues,
    this.allowDecimals = false,
    required this.onChanged,
  });

  @override
  State<SliderFormat> createState() => _SliderFormatState();
}

class _SliderFormatState extends State<SliderFormat> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.symmetric0_8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextFormat(
                  text: widget.labelLimit,
                  context: context,
                  type: "body",
                ),
              ),
              widget.isSingle
                  ? containerEdit(
                      context,
                      TextFormat(
                        text:
                            "${widget.valueDefault?.toCleanString()} ${widget.unit}",
                        context: context,
                        type: "body",
                      ),
                    )
                  : containerEdit(
                      context,
                      TextFormat(
                        text:
                            "${widget.rangeValues?.start.toCleanString()} - ${widget.rangeValues?.end.toCleanString()} ${widget.unit}",
                        context: context,
                        type: "body",
                      ),
                    ),
            ],
          ),
          widget.isSingle
              ? Slider(
                  min: widget.min,
                  max: widget.max,
                  divisions: widget.divisions,
                  value: widget.valueDefault ?? widget.min,
                  onChanged: (val) => widget.onChanged(val),
                )
              : RangeSlider(
                  min: widget.min,
                  max: widget.max,
                  divisions: widget.divisions,
                  values:
                      widget.rangeValues ?? RangeValues(widget.min, widget.max),
                  onChanged: (val) => widget.onChanged(val),
                ),
        ],
      ),
    );
  }

  Widget containerEdit(BuildContext context, TextFormat child) {
    return InkWell(
      borderRadius: AppBorder.all8,
      onTap: editDialog,
      child: Container(
        padding: AppPadding.symmetric0_8,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }

  void editDialog() {
    List<TextInputFormatter> inputFormatters = [
      if (!widget.allowDecimals) FilteringTextInputFormatter.digitsOnly,
    ];

    if (widget.isSingle) {
      ValueDialog.show(
        context: context,
        title: "Editar ${widget.labelLimit.toLowerCase()}",
        valueDefault: widget.valueDefault ?? widget.min,
        min: widget.min,
        max: widget.max,
        unit: widget.unit,
        allowDecimals: widget.allowDecimals,
        onSaved: (val) => widget.onChanged(val),
      );
      // En caso de no ser un slider simple, se crea un dialog con dos edit controllers para editar el rango.
    } else {
      TextEditingController startController = TextEditingController(
        text: widget.rangeValues?.start.toCleanString(),
      );
      TextEditingController endController = TextEditingController(
        text: widget.rangeValues?.end.toCleanString(),
      );

      showDialog(
        context: context,
        builder: (context) {
          return DialogEmergent(
            title: "Editar ${widget.labelLimit}",
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldFormat(
                    maxLength: 5,
                    controller: startController,
                    keyboardType: TextInputType.number,
                    inputFormatters: inputFormatters,
                    labelText: "Valor inicial (${widget.unit})",
                    icon: AppIcon.edit(context: context),
                    validator: (val) =>
                        AppValidators.validateNumber(context, val),
                  ),
                  TextFieldFormat(
                    maxLength: 5,
                    controller: endController,
                    keyboardType: TextInputType.number,
                    inputFormatters: inputFormatters,
                    labelText: "Valor final (${widget.unit})",
                    icon: AppIcon.edit(context: context),
                    validator: (val) =>
                        AppValidators.validateNumber(context, val),
                  ),
                ],
              ),
            ),
            onPressed: () {
              // Se convierte los valores del controlador a double.
              double valueMin = double.parse(startController.text);
              double valueMax = double.parse(endController.text);
              // Se valida que el rango esté dentro del rango permitido, si sobrepasa, se le asigna el valor máximo o mínimo.
              if (valueMin < widget.min) valueMin = widget.min;
              if (valueMin > widget.max) valueMin = widget.max;

              if (valueMax < widget.min) valueMax = widget.min;
              if (valueMax > widget.max) valueMax = widget.max;

              // Redondear para evitar errores de precisión.
              valueMin = double.parse(valueMin.toCleanString());
              valueMax = double.parse(valueMax.toCleanString());

              // Se valida que el valor inicial no sea mayor al valor final.
              if (valueMin > valueMax) {
                double tempMax = valueMin;
                valueMin = valueMax;
                valueMax = tempMax;
              }

              widget.onChanged(RangeValues(valueMin, valueMax));
              Navigator.pop(context);
            },
            formKey: formKey,
          );
        },
      );
    }
  }
}
