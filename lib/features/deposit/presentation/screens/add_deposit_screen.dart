import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/utils/permission_service.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/core/widgets/switch_format.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/deposit/data/models/deposit_model.dart';
import 'package:aqua_steward/features/deposit/data/models/sensor_model.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDepositScreen extends StatefulWidget {
  final Map<String, dynamic>? depositData;
  const AddDepositScreen({super.key, this.depositData});

  @override
  State<AddDepositScreen> createState() => _AddDepositScreenState();
}

class _AddDepositScreenState extends State<AddDepositScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late List<bool> _switchValues;
  final List<Icon> _icon = [
    AppIcon.waterDrop,
    AppIcon.scienceRounded,
    AppIcon.water,
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.depositData;

    if (data != null) {
      // Modo edición, para que se pueda editar el depósito existente.
      _ipController.text = (data["ip"] as String?) ?? "";
      _nameController.text = (data["name"] as String?) ?? "";

      // Lee el estado de cada sensor soportando tanto SensorModel como Map.
      final sensors = data["sensors"] as List?;
      if (sensors != null && sensors.length >= 3) {
        _switchValues = [
          _getSensorState(sensors[0]),
          _getSensorState(sensors[1]),
          _getSensorState(sensors[2]),
        ];
      } else {
        _switchValues = [true, false, false];
      }
    } else {
      // Modo creación: valores por defecto.
      _switchValues = [true, false, false];
    }
  }

  /// Extrae el estado del sensor soportando tanto SensorModel como Map.
  bool _getSensorState(dynamic sensor) {
    if (sensor is Map) return sensor["state"] as bool? ?? false;
    // Es un objeto Sensor/SensorModel con propiedad .state
    return sensor.state as bool? ?? false;
  }

  @override
  void dispose() {
    _ipController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _goToSettings() async {
    // Determina si es una actualización o una creación según la presencia del ID.
    final String? depositId = widget.depositData?["id"] as String?;
    final bool isEditing = depositId != null && depositId.isNotEmpty;

    if (isEditing) {
      // Modo edición: actualiza directamente con los umbrales existentes.
      await _updateDeposit(depositId);
    } else {
      // Modo creación: navega a la pantalla de umbrales.
      await _navigateToThresholds();
    }
  }

  // Actualiza el depósito directamente preservando los umbrales existentes.
  Future<void> _updateDeposit(String depositId) async {
    final data = widget.depositData!;
    final sensors = data["sensors"] as List?;

    // Construye los sensores con los estados actualizados y los umbrales originales.
    List<SensorModel> newSensors = [];
    if (sensors != null) {
      for (int i = 0; i < sensors.length; i++) {
        final sensor = sensors[i];
        final String? type = sensor is Map ? sensor["type"] : sensor.type;
        final String? unit = sensor is Map ? sensor["unit"] : sensor.unit;
        final double? minVal = sensor is Map
            ? (sensor["min_value"] as num?)?.toDouble()
            : sensor.minValue;
        final double? maxVal = sensor is Map
            ? (sensor["max_value"] as num?)?.toDouble()
            : sensor.maxValue;

        // Asigna el estado actualizado según el índice del sensor.
        bool updatedState = _switchValues[i];

        newSensors.add(
          SensorModel(
            type: type,
            state: updatedState,
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

    final DepositModel updatedDeposit = DepositModel(
      name: _nameController.text,
      ip: _ipController.text,
      capacity: (data["capacity"] as num?)?.toDouble(),
      installation_height: (data["installation_height"] as num?)?.toDouble(),
      fill_gap: (data["fill_gap"] as num?)?.toDouble(),
      owner_id: currentUser?.id ?? "",
      sensors: newSensors,
    );

    // Instancia el caso de uso a través del provider global para mantener la actualización sincronizado.
    final result = await context.read<DepositProvider>().updateDeposit(
      depositId: depositId,
      deposit: updatedDeposit,
      token: token,
    );

    if (mounted) {
      if (result.isSuccess) {
        SnackBarFormat.show(
          context,
          context.l10n.snackbar_deposito_actualizado,
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

  // Navega a la pantalla de configuración de umbrales (flujo de creación).
  Future<void> _navigateToThresholds() async {
    List<Map<String, dynamic>> sensorsList = [
      {"type": "HC-SR04", "state": _switchValues[0], "unit": "L"},
      {"type": "PH-4502C", "state": _switchValues[1], "unit": "pH"},
      {"type": "TS300B", "state": _switchValues[2], "unit": "NTU"},
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
      titleAppBar: context.l10n.titulo_agregar_deposito,
      children: [
        TextFormat(
          text: context.l10n.deposito_sensores_instalados,
          context: context,
          type: "subtitle",
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ContainerFormat(
            children: [
              SwitchFormat(
                title: [
                  context.l10n.deposito_sensor_nivel_nombre,
                  context.l10n.deposito_sensor_ph_nombre,
                  context.l10n.deposito_sensor_turbidez_nombre,
                ][index],
                subtitle: [
                  context.l10n.deposito_sensor_nivel_desc,
                  context.l10n.deposito_sensor_ph_desc,
                  context.l10n.deposito_sensor_turbidez_desc,
                ][index],
                value: _switchValues[index],
                icon: _icon[index],
                onChanged: (newSwitchValue) {
                  setState(() {
                    _switchValues[index] = newSwitchValue;
                  });
                  SnackBarFormat.show(
                    context,
                    _switchValues[index]
                        ? context.l10n.snackbar_alertas_activas
                        : context.l10n.snackbar_alertas_inactivas,
                  );
                },
              ),
            ],
          ),
          separatorBuilder: (context, index) => AppSizedBox.height12,
          itemCount: 3,
        ),

        // Tarjeta que solicita IP y nombre para el depósito.
        TextFormat(
          text: context.l10n.deposito_info_kit,
          context: context,
          type: "subtitle",
        ),
        ContainerFormat(
          children: [
            Padding(
              padding: AppPadding.all8,
              child: Column(
                children: [
                  TextFormat(
                    text: context.l10n.deposito_ingresa_ip,
                    context: context,
                    alignCenter: true,
                    type: "body",
                  ),
                  TextFieldFormat(
                    labelText: context.l10n.deposito_ip_label,
                    icon: AppIcon.wifi,
                    keyboardType: TextInputType.number,
                    controller: _ipController,
                    maxLength: 15,
                    validator: (val) => AppValidators.validateIP(context, val),
                    suffixIcon: ButtonFormat(
                      type: "icon",
                      icon: AppIcon.qrCodeScanner,
                      onConfirm: () async {
                        // Solicita o verifica el permiso de la cámara al hacer clic
                        bool hasPermission =
                            await PermissionService.requestCameraPermission(
                              context,
                            );
                        if (hasPermission && context.mounted) {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRouter.scanner,
                          );

                          // Si el resultado del escáner no es nulo y es un String, se asigna al text field
                          if (result != null &&
                              result is String &&
                              context.mounted) {
                            setState(() {
                              _ipController.text = result;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  AppSizedBox.height12,
                  TextFormat(
                    text: context.l10n.deposito_ingresa_nombre,
                    context: context,
                    alignCenter: true,
                    type: "body",
                  ),
                  TextFieldFormat(
                    labelText: context.l10n.deposito_nombre_label,
                    icon: AppIcon.waterDamageOutlined,
                    controller: _nameController,
                    maxLength: 20,
                    validator: (val) =>
                        AppValidators.validateRequired(context, val),
                  ),
                  ButtonFormat(
                    formKey: _formKey,
                    label: context.l10n.comun_confirmar,
                    onConfirm: _goToSettings,
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
