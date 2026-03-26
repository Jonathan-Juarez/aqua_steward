import 'package:aqua_steward/controller/auth_controller.dart';
import 'package:aqua_steward/controller/deposit_controller.dart';
import 'package:aqua_steward/entity/deposit.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:flutter/material.dart';

class SettingsThresholdScreen extends StatefulWidget {
  final Map<String, dynamic> depositData;

  const SettingsThresholdScreen({super.key, required this.depositData});

  @override
  State<SettingsThresholdScreen> createState() =>
      _SettingsThresholdScreenState();
}

class _SettingsThresholdScreenState extends State<SettingsThresholdScreen> {
  // Valores iniciales
  double _depositHeight = 30.0, _depositCapacity = 7.6, _fillGap = 4.0;
  double _minTurbidity = 1.0, _maxTurbidity = 5.0;
  double _minPH = 6.5, _maxPH = 8.5;

  void _createDeposit() {
    // Se crea ingresa los datos del nuevo depósito
    final Deposit newDeposit = Deposit(
      name: widget.depositData["name"],
      ip: widget.depositData["ip"],
      capacity: _depositCapacity.toInt(),
      installation_height: _depositHeight,
      fill_gap: _fillGap,
      owner_id: AuthController.currentUser?.id ?? "",
      sensors: widget.depositData["sensors"],
    );

    // Se llama al controlador para crear el depósito
    DepositController().createDeposit(context: context, deposit: newDeposit);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: "Configuraciones",
      children: [
        Padding(
          padding: AppPadding.symmetric16_0,
          child: Text(
            "Límites y umbrales",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        containerLimitSettings(),
        AppSizedBox.height16,
        ButtonMain(label: "Confirmar", onPressed: _createDeposit),
      ],
    );
  }

  ContainerFormat containerLimitSettings() {
    return ContainerFormat(
      children: [
        // Altura del depósito
        sliderLimitParameter(
          0,
          140,
          "Altura del depósito",
          "CM",
          _depositHeight, // Usamos la variable específica para altura
          100,
          (newValue) => setState(() => _depositHeight = newValue),
        ),

        // Capacidad del depósito
        sliderLimitParameter(
          0,
          100,
          "Capacidad del depósito",
          "L",
          _depositCapacity, // Usamos la variable específica para capacidad
          100,
          (newValue) => setState(() => _depositCapacity = newValue),
        ),

        // Distancia entre el depósitos lleno y el sensor instalado (espacio vacío)
        sliderLimitParameter(
          0,
          100,
          "Espacio vacío",
          "CM",
          _fillGap,
          100,
          (newValue) => setState(() => _fillGap = newValue),
        ),

        // Turbidez
        sliderLimitParameter(
          0,
          5,
          "Turbidez mínima",
          "NTU",
          _minTurbidity,
          100,
          (newValue) => setState(() => _minTurbidity = newValue),
        ),
        sliderLimitParameter(
          0,
          10,
          "Turbidez máxima",
          "NTU",
          _maxTurbidity,
          100,
          (newValue) => setState(() => _maxTurbidity = newValue),
        ),

        // pH
        sliderLimitParameter(
          0,
          14,
          "pH mínimo",
          "pH",
          _minPH,
          140,
          (newValue) => setState(() => _minPH = newValue),
        ),
        sliderLimitParameter(
          0,
          14,
          "pH máximo",
          "pH",
          _maxPH,
          140,
          (newValue) => setState(() => _maxPH = newValue),
        ),
      ],
    );
  }

  Widget sliderLimitParameter(
    double min,
    double max,
    String labelLimit,
    String unit,
    double valueLimit,
    int divisions,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: AppPadding.all16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  labelLimit,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                "${valueLimit.toStringAsFixed(1)} $unit",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Slider(
            min: min,
            max: max,
            divisions: divisions,
            value: valueLimit,
            onChanged: onChanged,
          ),
          AppSizedBox.height8,
        ],
      ),
    );
  }
}
