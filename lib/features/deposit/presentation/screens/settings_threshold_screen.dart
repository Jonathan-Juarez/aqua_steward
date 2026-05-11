import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/features/deposit/data/models/deposit_model.dart';
import 'package:aqua_steward/features/deposit/data/models/sensor_model.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:aqua_steward/features/deposit/presentation/widgets/slider_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsThresholdScreen extends StatefulWidget {
  final Map<String, dynamic> depositData;

  const SettingsThresholdScreen({super.key, required this.depositData});

  @override
  State<SettingsThresholdScreen> createState() =>
      _SettingsThresholdScreenState();
}

class _SettingsThresholdScreenState extends State<SettingsThresholdScreen> {
  // Valores de medidas del depósito.
  late double _depositHeight;
  late double _depositCapacity;
  late double _fillGap;
  late double _maxTurbidity;

  // Valores de rangos de sensores.
  late RangeValues _levelRange;
  late RangeValues _phRange;

  @override
  void initState() {
    super.initState();
    final data = widget.depositData;

    // Inicializa con los valores del depósito existente o con defaults para nuevos.
    _depositCapacity = (data["capacity"] as num?)?.toDouble() ?? 100;
    _depositHeight = (data["installation_height"] as num?)?.toDouble() ?? 50;
    _fillGap = (data["fill_gap"] as num?)?.toDouble() ?? 10;

    // Valores por defecto para los rangos de sensores.
    double levelMin = 10.0;
    double levelMax = 90.0;
    double phMin = 6.5;
    double phMax = 8.5;
    _maxTurbidity = 5.0;

    // Lee los valores reales de los sensores si vienen del depósito existente.
    final sensors = data["sensors"];
    if (sensors != null) {
      for (var sensor in sensors) {
        // Soporta tanto SensorModel como Map<String, dynamic>.
        final String? type = sensor is Map ? sensor["type"] : sensor.type;
        final double? minVal = sensor is Map
            ? (sensor["min_value"] as num?)?.toDouble()
            : sensor.minValue;
        final double? maxVal = sensor is Map
            ? (sensor["max_value"] as num?)?.toDouble()
            : sensor.maxValue;

        if (type == "HC-SR04") {
          levelMin = minVal ?? levelMin;
          levelMax = maxVal ?? levelMax;
        } else if (type == "PH-4502C") {
          phMin = minVal ?? phMin;
          phMax = maxVal ?? phMax;
        } else if (type == "TS300B") {
          _maxTurbidity = maxVal ?? _maxTurbidity;
        }
      }
    }

    _levelRange = RangeValues(levelMin, levelMax);
    _phRange = RangeValues(phMin, phMax);
  }

  // Procesa la información de los umbrales y delega la creación o actualización al proveedor.
  void _saveDeposit() async {
    List<SensorModel> newSensors = [];
    // Se recorren los sensores para actualizar sus valores.
    if (widget.depositData["sensors"] != null) {
      for (var sensor in widget.depositData["sensors"]) {
        // Extrae propiedades soportando tanto Map como SensorModel/Sensor.
        final String? type = sensor is Map ? sensor["type"] : sensor.type;
        final bool? state = sensor is Map ? sensor["state"] : sensor.state;
        final String? unit = sensor is Map ? sensor["unit"] : sensor.unit;

        double? minVal;
        double? maxVal;
        // Se actualizan los valores de los sensores según su tipo.
        if (type == "HC-SR04") {
          minVal = _levelRange.start;
          maxVal = _levelRange.end;
        } else if (type == "PH-4502C") {
          minVal = _phRange.start;
          maxVal = _phRange.end;
        } else if (type == "TS300B") {
          maxVal = _maxTurbidity;
        }

        // Se agrega el sensor a la lista de sensores.
        newSensors.add(
          SensorModel(
            type: type,
            state: state,
            unit: unit,
            minValue: minVal,
            maxValue: maxVal,
          ),
        );
      }
    }

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;
    final token = currentUser?.token ?? "";
    // Se obtiene el id del depósito si existe.
    final String? depositId = widget.depositData["id"] as String?;
    // Se verifica si el depósito existe para saber si se debe crear o actualizar.
    final bool isEditing = depositId != null && depositId.isNotEmpty;

    // Se crea el depósito con los valores completos.
    final DepositModel newDeposit = DepositModel(
      id: depositId,
      name: widget.depositData["name"],
      ip: widget.depositData["ip"],
      capacity: _depositCapacity,
      installation_height: _depositHeight,
      fill_gap: _fillGap,
      owner_id: currentUser?.id ?? "",
      sensors: newSensors,
    );

    final Result<void> result;
    if (isEditing) {
      // Actualiza el depósito existente en la base de datos.
      result = await context.read<DepositProvider>().updateDeposit(
        depositId: depositId,
        deposit: newDeposit,
        token: token,
      );
    } else {
      // Crea el depósito en la base de datos entregando los datos y el token de sesión.
      result = await context.read<DepositProvider>().createDeposit(
        deposit: newDeposit,
        token: token,
      );
    }

    // Valida la vigencia del contexto tras la operación asíncrona de red.
    if (mounted) {
      if (result.isSuccess) {
        SnackBarFormat.show(
          context,
          isEditing
              ? context.l10n.snackbar_deposito_actualizado
              : context.l10n.snackbar_deposito_creado,
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.dashboard,
          (route) => false,
        );
      } else {
        SnackBarFormat.show(context, result.error ?? "Error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_configurar_umbrales,
      children: [
        TextFormat(
          text: context.l10n.umbrales_medidas_deposito,
          context: context,
          type: "subtitle",
        ),
        TextFormat(
          text: context.l10n.umbrales_medidas_desc,
          context: context,
          alignCenter: true,
          type: "body",
        ),
        AppSizedBox.height12,
        ContainerFormat(
          children: [
            SliderFormat(
              isSingle: true,
              min: 0,
              max: 1000,
              divisions: 100,
              labelLimit: context.l10n.umbrales_capacidad,
              unit: "L",
              valueLimit: _depositCapacity,
              onChanged: (val) => setState(() => _depositCapacity = val),
            ),
            SliderFormat(
              isSingle: true,
              min: 0,
              max: 150,
              divisions: 150,
              labelLimit: context.l10n.umbrales_altura,
              unit: "CM",
              valueLimit: _depositHeight,
              onChanged: (val) => setState(() => _depositHeight = val),
            ),
            SliderFormat(
              isSingle: true,
              min: 0,
              max: 50,
              divisions: 50,
              labelLimit: context.l10n.umbrales_espacio_sensor,
              unit: "CM",
              valueLimit: _fillGap,
              onChanged: (val) => setState(() => _fillGap = val),
            ),
          ],
        ),
        TextFormat(
          text: context.l10n.umbrales_titulo,
          context: context,
          type: "subtitle",
        ),
        TextFormat(
          text: context.l10n.umbrales_desc,
          context: context,
          alignCenter: true,
          type: "body",
        ),
        AppSizedBox.height12,
        ContainerFormat(
          children: [
            SliderFormat(
              min: 10,
              max: 90,
              divisions: 80,
              labelLimit: context.l10n.umbrales_nivel_permitido,
              unit: "%",
              rangeValues: _levelRange,
              onChanged: (val) => setState(() => _levelRange = val),
            ),
            SliderFormat(
              min: 0,
              max: 14,
              divisions: 140,
              labelLimit: context.l10n.umbrales_ph_optimo,
              unit: "pH",
              rangeValues: _phRange,
              onChanged: (val) => setState(() => _phRange = val),
            ),
            SliderFormat(
              isSingle: true,
              min: 0,
              max: 3000,
              divisions: 60,
              labelLimit: context.l10n.umbrales_turbidez_maxima,
              unit: "NTU",
              valueLimit: _maxTurbidity,
              onChanged: (val) => setState(() => _maxTurbidity = val),
            ),
          ],
        ),

        AppSizedBox.height12,

        ButtonFormat(
          label: context.l10n.comun_confirmar,
          onConfirm: _saveDeposit,
        ),
      ],
    );
  }
}
