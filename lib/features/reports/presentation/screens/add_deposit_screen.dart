import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/core/widgets/switch_format.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:flutter/material.dart';

class AddDepositScreen extends StatefulWidget {
  const AddDepositScreen({super.key});

  @override
  State<AddDepositScreen> createState() => _AddDepositScreenState();
}

class _AddDepositScreenState extends State<AddDepositScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final List<bool> _switchValues = [true, false, false];
  final List<String> _labelSettings = [
    "Sensor de nivel",
    "Sensor de turbidez",
    "Sensor de pH",
  ];
  final List<String> _subtitleSettings = [
    "Sensor HC-SR04",
    "Sensor TS300B",
    "Sensor PH-4502C",
  ];
  final List<Icon> _icon = [
    AppIcon.waterDrop,
    AppIcon.water,
    AppIcon.scienceRounded,
  ];

  @override
  void dispose() {
    _ipController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _goToSettings() async {
    if (_nameController.text.isEmpty) {
      SnackBarFormat.show(context, "Por favor ingresa un nombre");
      return;
    }

    List<Map<String, dynamic>> sensorsList = [
      {"type": "HC-SR04", "state": _switchValues[0], "unit": "L"},
      {"type": "TS300B", "state": _switchValues[1], "unit": "NTU"},
      {"type": "PH-4502C", "state": _switchValues[2], "unit": "pH"},
    ];

    final result = await Navigator.pushNamed(
      context,
      AppRouter.settingsThreshold,
      arguments: {
        "depositData": {
          "name": _nameController.text,
          "ip": _ipController.text,
          "sensors": sensorsList,
        },
      },
    );

    // Si Settings regresó con datos, los pasamos hacia atrás (al Home)
    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      formKey: _formKey,
      titleAppBar: "Depósito de agua",
      children: [
        Padding(
          padding: AppPadding.symmetric16_0,
          child: Text(
            "Sensores instalados",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ContainerFormat(
            children: [
              SwitchFormat(
                title: _labelSettings[index],
                subtitle: _subtitleSettings[index],
                value: _switchValues[index],
                icon: _icon[index],
                onChanged: (newSwitchValue) {
                  setState(() {
                    _switchValues[index] = newSwitchValue;
                  });
                  SnackBarFormat.show(
                    context,
                    _switchValues[index]
                        ? "Recibirás lecturas y alertas"
                        : "No recibirás lecturas y alertas",
                  );
                },
              ),
            ],
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: 3,
        ),

        // Tarjeta que solicita IP y nombre para el depósito.
        Padding(
          padding: AppPadding.symmetric16_0,
          child: Text(
            "Personalización",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),

        ContainerFormat(
          children: [
            Padding(
              padding: AppPadding.all16,
              child: Column(
                children: [
                  Text(
                    "Ingresar IP del kit de agua",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFieldFormat(
                    labelText: "IP",
                    icon: AppIcon.wifi,
                    keyboardType: TextInputType.number,
                    controller: _ipController,
                    maxLength: 15,
                    validator: AppValidators.validateRequired,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Ingresar nombre del deposito de agua",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFieldFormat(
                    labelText: "Deposito",
                    icon: AppIcon.waterDamageOutlined,
                    controller: _nameController,
                    maxLength: 20,
                    validator: AppValidators.validateRequired,
                  ),
                  ButtonMain(
                    formKey: _formKey,
                    label: "Confirmar",
                    onPressed: _goToSettings,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
