import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:flutter/material.dart';

class SliderFormat extends StatefulWidget {
  final bool isSingle;
  final double min;
  final double max;
  final int divisions;
  final String labelLimit;
  final String unit;
  final double? valueLimit;
  final RangeValues? rangeValues;
  final ValueChanged<dynamic> onChanged;
  const SliderFormat({
    super.key,
    this.isSingle = false,
    required this.min,
    required this.max,
    required this.divisions,
    required this.labelLimit,
    required this.unit,
    this.valueLimit,
    this.rangeValues,
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
                            "${widget.valueLimit?.toStringAsFixed(1)} ${widget.unit}",
                        context: context,
                        type: "body",
                      ),
                    )
                  : containerEdit(
                      context,
                      TextFormat(
                        text:
                            "${widget.rangeValues?.start.toStringAsFixed(1)} - ${widget.rangeValues?.end.toStringAsFixed(1)} ${widget.unit}",
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
                  value: widget.valueLimit ?? widget.min,
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
    if (widget.isSingle) {
      TextEditingController limitController = TextEditingController(
        text: widget.valueLimit?.toStringAsFixed(1),
      );

      showDialog(
        context: context,
        builder: (context) {
          return DialogEmergent(
            title: "Editar ${widget.labelLimit.toLowerCase()}",
            content: Form(
              key: formKey,
              child: TextFieldFormat(
                maxLength: 5,
                controller: limitController,
                keyboardType: TextInputType.number,
                labelText: "Valor en ${widget.unit}",
                icon: AppIcon.edit(context: context),
                validator: (val) => AppValidators.validateNumber(context, val),
              ),
            ),
            onPressed: () {
              // Se convierte el valor del controlador a double.
              double limitValue = double.parse(limitController.text);
              // Se valida que el número esté dentro del rango permitido, si sobrepasa, se le asigna el valor máximo o mínimo.
              if (limitValue < widget.min) limitValue = widget.min;
              if (limitValue > widget.max) limitValue = widget.max;

              // Redondear para evitar errores de precisión.
              limitValue = double.parse(limitValue.toStringAsFixed(1));
              widget.onChanged(limitValue);

              Navigator.pop(context);
            },
            formKey: formKey,
          );
        },
      );
    } else {
      TextEditingController startController = TextEditingController(
        text: widget.rangeValues?.start.toStringAsFixed(1),
      );
      TextEditingController endController = TextEditingController(
        text: widget.rangeValues?.end.toStringAsFixed(1),
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
                    labelText: "Valor inicial (${widget.unit})",
                    icon: AppIcon.edit(context: context),
                    validator: (val) =>
                        AppValidators.validateNumber(context, val),
                  ),
                  TextFieldFormat(
                    maxLength: 5,
                    controller: endController,
                    keyboardType: TextInputType.number,
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
              valueMin = double.parse(valueMin.toStringAsFixed(1));
              valueMax = double.parse(valueMax.toStringAsFixed(1));

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
