import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/utils/permission_service.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/features/deposit/presentation/widgets/value_dialog.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';
import 'package:aqua_steward/features/deposit/domain/entities/sensor.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:aqua_steward/features/deposit/presentation/widgets/slider_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositScreen extends StatefulWidget {
  final Map<String, dynamic>? depositData;
  const DepositScreen({super.key, this.depositData});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Estado de los sensores: [nivel, pH, turbidez].
  late List<bool> _switchValues;
  final List<Icon> _sensorIcons = [
    AppIcon.waterDrop,
    AppIcon.scienceRounded,
    AppIcon.water,
  ];

  // Dimensiones del depósito.
  late double _depositCapacity;
  late double _depositHeight;
  late double _fillGap;

  // Umbrales de alerta.
  late RangeValues _levelRange;
  late RangeValues _phRange;
  late double _maxTurbidity;

  @override
  void initState() {
    super.initState();
    final data = widget.depositData;

    if (data != null) {
      // Modo edición: carga los valores existentes del depósito.
      _ipController.text = (data["ip"] as String?) ?? "";
      _nameController.text = (data["name"] as String?) ?? "";

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

      _depositCapacity = (data["capacity"] as num?)?.toDouble() ?? 100;
      _depositHeight = (data["installation_height"] as num?)?.toDouble() ?? 50;
      _fillGap = (data["fill_gap"] as num?)?.toDouble() ?? 10;

      // Lee los umbrales existentes de cada sensor.
      double levelMin = 10.0;
      double levelMax = 90.0;
      double phMin = 6.5;
      double phMax = 8.5;
      _maxTurbidity = 5.0;

      if (sensors != null) {
        for (var sensor in sensors) {
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
    } else {
      // Modo creación: valores por defecto.
      _switchValues = [true, false, false];
      _depositCapacity = 100;
      _depositHeight = 50;
      _fillGap = 10;
      _levelRange = const RangeValues(10.0, 90.0);
      _phRange = const RangeValues(6.5, 8.5);
      _maxTurbidity = 5.0;
    }
  }

  // Extrae el estado del sensor soportando tanto SensorModel como Map.
  bool _getSensorState(dynamic sensor) {
    if (sensor is Map) return sensor["state"] as bool? ?? false;
    return sensor.state as bool? ?? false;
  }

  @override
  void dispose() {
    _ipController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Construye la lista de sensores con sus estados y umbrales actualizados.
  List<Sensor> _buildSensors() {
    return [
      Sensor(
        type: "HC-SR04",
        state: _switchValues[0],
        unit: "L",
        minValue: _levelRange.start,
        maxValue: _levelRange.end,
      ),
      Sensor(
        type: "PH-4502C",
        state: _switchValues[1],
        unit: "pH",
        minValue: _phRange.start,
        maxValue: _phRange.end,
      ),
      Sensor(
        type: "TS300B",
        state: _switchValues[2],
        unit: "NTU",
        maxValue: _maxTurbidity,
      ),
    ];
  }

  // Procesa la información completa y delega la creación o actualización al proveedor.
  void _saveDeposit() async {
    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;
    final token = currentUser?.token ?? "";

    final String? depositId = widget.depositData?["id"] as String?;
    final bool isEditing = depositId != null && depositId.isNotEmpty;

    final Deposit deposit = Deposit(
      id: depositId,
      name: _nameController.text,
      ip: _ipController.text,
      capacity: _depositCapacity,
      installation_height: _depositHeight,
      fill_gap: _fillGap,
      owner_id: currentUser?.id ?? "",
      sensors: _buildSensors(),
    );

    final Result<void> result;
    if (isEditing) {
      result = await context.read<DepositProvider>().updateDeposit(
        depositId: depositId,
        deposit: deposit,
        token: token,
      );
    } else {
      result = await context.read<DepositProvider>().createDeposit(
        deposit: deposit,
        token: token,
      );
    }

    if (mounted) {
      if (result.isSuccess) {
        SnackBarFormat(
          context: context,
          message: isEditing
              ? context.l10n.snackbar_deposito_actualizado
              : context.l10n.snackbar_deposito_creado,
        ).show();

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.mainNavigation,
          (route) => false,
          arguments: {"args": _switchValues},
        );
      } else {
        SnackBarFormat(
          context: context,
          message: result.error ?? "Error",
          isError: true,
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      formKey: _formKey,
      titleAppBar: context.l10n.comun_deposito,
      children: [
        // Información del Kit
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
                        bool hasPermission =
                            await PermissionService.requestCameraPermission(
                              context,
                            );
                        if (hasPermission && context.mounted) {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRouter.scanner,
                          );

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
                    labelText: context.l10n.comun_deposito,
                    icon: AppIcon.waterDamageOutlined,
                    controller: _nameController,
                    maxLength: 20,
                    validator: (val) =>
                        AppValidators.validateRequired(context, val),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Sensores Instalados
        TextFormat(
          text: context.l10n.deposito_sensores_instalados,
          context: context,
          type: "subtitle",
        ),
        ContainerFormat(
          children: [
            Row(
              children: List.generate(3, (index) {
                final isSelected = _switchValues[index];
                final titles = [
                  context.l10n.deposito_sensor_nivel_nombre,
                  context.l10n.deposito_sensor_ph_nombre,
                  context.l10n.deposito_sensor_turbidez_nombre,
                ];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _switchValues[index] = !_switchValues[index];
                        });
                        SnackBarFormat(
                          context: context,
                          message: _switchValues[index]
                              ? context.l10n.snackbar_alertas_activas
                              : context.l10n.snackbar_alertas_inactivas,
                        ).show();
                      },
                      borderRadius: AppBorder.all8,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: AppPadding.all8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.transparent
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.05),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.1),
                            width: 0.5,
                          ),
                          borderRadius: AppBorder.all8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Opacity(
                              opacity: isSelected ? 1.0 : 0.4,
                              child: _sensorIcons[index],
                            ),
                            AppSizedBox.height8,
                            TextFormat(
                              text: titles[index],
                              context: context,
                              type: isSelected ? "body" : "bodySecondary",
                              alignCenter: true,
                            ),
                            const SizedBox(height: 4),
                            isSelected
                                ? AppIcon.checkCircle
                                : AppIcon.addCircleOutline(context: context),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),

        // Dimensiones del Depósito si está activo el sensor de nivel
        if (_switchValues[0]) ...[
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
          ContainerListTile(
            title: context.l10n.umbrales_capacidad,
            subtitle: "${_depositCapacity.toInt()} L",
            subsubtitle: context.l10n.comun_rango("0", "1000", "L"),
            icon: AppIcon.localDrinkOutlined,
            onTap: () => ValueDialog.show(
              context: context,
              title: context.l10n.umbrales_capacidad,
              valueDefault: _depositCapacity,
              min: 0,
              max: 1000,
              unit: "L",
              onSaved: (val) => setState(() => _depositCapacity = val),
            ),
          ),
          AppSizedBox.height12,
          ContainerListTile(
            title: context.l10n.umbrales_altura,
            subtitle: "${_depositHeight.toInt()} CM",
            subsubtitle: context.l10n.comun_rango("0", "150", "CM"),
            icon: AppIcon.heightOutlined,
            onTap: () => ValueDialog.show(
              context: context,
              title: context.l10n.umbrales_altura,
              valueDefault: _depositHeight,
              min: 0,
              max: 150,
              unit: "CM",
              onSaved: (val) => setState(() => _depositHeight = val),
            ),
          ),
          AppSizedBox.height12,
          ContainerListTile(
            title: context.l10n.umbrales_espacio_sensor,
            subtitle: "${_fillGap.toInt()} CM",
            subsubtitle: context.l10n.comun_rango("0", "50", "CM"),
            icon: AppIcon.straightenOutlined,
            onTap: () => ValueDialog.show(
              context: context,
              title: context.l10n.umbrales_espacio_sensor,
              valueDefault: _fillGap,
              min: 0,
              max: 50,
              unit: "CM",
              onSaved: (val) => setState(() => _fillGap = val),
            ),
          ),
        ],

        // Umbrales de Alerta si está activo al menos un sensor
        if (_switchValues[0] || _switchValues[1] || _switchValues[2]) ...[
          TextFormat(
            text: context.l10n.comun_umbrales,
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
              // Slider de nivel visible si el sensor de nivel está activo
              if (_switchValues[0])
                SliderFormat(
                  min: 10,
                  max: 90,
                  divisions: 80,
                  labelLimit: context.l10n.umbrales_nivel_permitido,
                  unit: "%",
                  rangeValues: _levelRange,
                  onChanged: (val) => setState(() => _levelRange = val),
                ),
              // Slider de pH visible si el sensor de pH está activo
              if (_switchValues[1])
                SliderFormat(
                  min: 0,
                  max: 14,
                  divisions: 140,
                  labelLimit: context.l10n.umbrales_ph_optimo,
                  unit: "pH",
                  rangeValues: _phRange,
                  allowDecimals: true,
                  onChanged: (val) => setState(() => _phRange = val),
                ),
              // Slider de turbidez visible si el sensor de turbidez está activo
              if (_switchValues[2])
                SliderFormat(
                  isSingle: true,
                  min: 0,
                  max: 3000,
                  divisions: 60,
                  labelLimit: context.l10n.umbrales_turbidez_maxima,
                  unit: "NTU",
                  valueDefault: _maxTurbidity,
                  onChanged: (val) => setState(() => _maxTurbidity = val),
                ),
            ],
          ),
        ],

        AppSizedBox.height12,

        ButtonFormat(
          formKey: _formKey,
          label: context.l10n.comun_confirmar,
          onConfirm: _saveDeposit,
        ),
      ],
    );
  }
}
