import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
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
import 'package:aqua_steward/core/utils/permission_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositScreen extends StatefulWidget {
  final Deposit? deposit;
  const DepositScreen({super.key, this.deposit});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _showManualMac = false;
  double? _latitude;
  double? _longitude;
  bool _isGettingLocation = false;

  // Estado de los sensores: [nivel, pH, turbidez].
  late List<bool> _switchValues;
  final List<Widget> _sensorIcons = [
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
    final deposit = widget.deposit;

    if (deposit != null) {
      // Modo edición: carga los valores existentes del depósito.
      _ipController.text = deposit.ip ?? "";
      _nameController.text = deposit.name ?? "";

      final levelSensor = deposit.sensorOfType(SensorTypes.level);
      final phSensor = deposit.sensorOfType(SensorTypes.ph);
      final turbiditySensor = deposit.sensorOfType(SensorTypes.turbidity);

      if (levelSensor != null || phSensor != null || turbiditySensor != null) {
        _switchValues = [
          levelSensor?.state == true,
          phSensor?.state == true,
          turbiditySensor?.state == true,
        ];
      } else {
        _switchValues = [true, false, false];
      }

      _depositCapacity = deposit.capacity ?? 100;
      _depositHeight = deposit.installation_height ?? 50;
      _fillGap = deposit.fill_gap ?? 10;
      _latitude = deposit.latitude;
      _longitude = deposit.longitude;

      // Lee los umbrales existentes de cada sensor.
      final double levelMin = levelSensor?.minValue ?? 10.0;
      final double levelMax = levelSensor?.maxValue ?? 90.0;
      final double phMin = phSensor?.minValue ?? 6.5;
      final double phMax = phSensor?.maxValue ?? 8.5;
      _maxTurbidity = turbiditySensor?.maxValue ?? 5.0;

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
        type: SensorTypes.level,
        state: _switchValues[0],
        unit: "L",
        minValue: _levelRange.start,
        maxValue: _levelRange.end,
      ),
      Sensor(
        type: SensorTypes.ph,
        state: _switchValues[1],
        unit: "pH",
        minValue: _phRange.start,
        maxValue: _phRange.end,
      ),
      Sensor(
        type: SensorTypes.turbidity,
        state: _switchValues[2],
        unit: "NTU",
        maxValue: _maxTurbidity,
      ),
    ];
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      final hasPermission = await PermissionService.requestLocationPermission(
        context,
      );
      if (hasPermission) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
        if (mounted) {
          SnackBarFormat(
            context: context,
            message: context.l10n.ubicacion_obtenida_exito,
          );
        }
      }
    } catch (_) {
      if (mounted) {
        SnackBarFormat(
          context: context,
          message: context.l10n.ubicacion_error_obtener,
        );
      }
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  // Procesa la información completa y delega la creación o actualización al proveedor.
  void _saveDeposit() async {
    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;

    final macError = AppValidators.validateMac(context, _ipController.text);
    if (macError != null) {
      setState(() => _showManualMac = true);
      SnackBarFormat(context: context, message: macError);
      return;
    }

    final String? depositId = widget.deposit?.id;
    final bool isEditing = depositId != null && depositId.isNotEmpty;

    final Deposit deposit = Deposit(
      id: depositId,
      name: _nameController.text,
      ip: _ipController.text,
      capacity: _depositCapacity,
      installation_height: _depositHeight,
      fill_gap: _fillGap,
      latitude: _latitude,
      longitude: _longitude,
      owner_id: currentUser?.id ?? "",
      sensors: _buildSensors(),
    );

    final Result<void> result;
    if (isEditing) {
      result = await context.read<DepositProvider>().updateDeposit(
        depositId: depositId,
        deposit: deposit,
      );
    } else {
      result = await context.read<DepositProvider>().createDeposit(
        deposit: deposit,
      );
    }

    if (!mounted) return;

    if (context.processResult(
      result,
      successMessage: isEditing
          ? context.l10n.snackbar_deposito_actualizado
          : context.l10n.snackbar_deposito_creado,
    )) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.mainNavigation,
        (route) => false,
        arguments: {"args": _switchValues},
      );
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
                  // Si ya se vinculó o tiene una MAC seleccionada
                  if (_ipController.text.isNotEmpty) ...[
                    ContainerListTile(
                      icon: AppIcon.sensors,
                      title: context.l10n.deposito_kit_seleccionado,
                      subtitle: "MAC: ${_ipController.text}",
                      trailing: ButtonFormat(
                        type: "text",
                        label: context.l10n.deposito_cambiar_dispositivo,
                        onConfirm: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRouter.nearbyDevices,
                          );

                          if (result != null &&
                              result is String &&
                              context.mounted) {
                            setState(() {
                              _ipController.text = result;
                            });
                          }
                        },
                      ),
                    ),
                  ] else ...[
                    // Si no se ha vinculado un dispositivo, buscar uno cercano
                    ButtonFormat(
                      padding: EdgeInsets.zero,
                      icon: AppIcon.wifiFind(),
                      label: context.l10n.deposito_buscar_dispositivo,
                      onConfirm: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRouter.nearbyDevices,
                        );

                        if (result != null &&
                            result is String &&
                            context.mounted) {
                          setState(() {
                            _ipController.text = result;
                          });
                        }
                      },
                    ),
                  ],

                  // En caso de no encontrar el dispositivo, se puede ingresar manualmente
                  AppSizedBox.height12,
                  TextFormat(
                    text: context.l10n.deposito_manual_mac_desc,
                    context: context,
                    alignCenter: true,
                    type: "bodySecondary",
                  ),
                  ButtonFormat(
                    type: "text",
                    label: _showManualMac
                        ? context.l10n.deposito_ocultar_manual_mac
                        : context.l10n.deposito_ingreso_manual_mac,
                    onConfirm: () {
                      setState(() {
                        _showManualMac = !_showManualMac;
                      });
                    },
                  ),

                  if (_showManualMac) ...[
                    TextFieldFormat(
                      labelText: context.l10n.deposito_ip_label,
                      hintText: context.l10n.deposito_ip_hint,
                      icon: AppIcon.sensors,
                      keyboardType: TextInputType.text,
                      controller: _ipController,
                      maxLength: 17,
                      validator: (val) =>
                          AppValidators.validateMac(context, val),
                    ),
                  ],

                  AppSizedBox.height12,
                  TextFormat(
                    text: context.l10n.deposito_ingresa_nombre,
                    context: context,
                    alignCenter: true,
                    type: "bodySecondary",
                  ),
                  TextFieldFormat(
                    labelText: context.l10n.comun_deposito,
                    hintText: context.l10n.deposito_nombre_hint,
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
        TextFormat(
          text: context.l10n.deposito_sensores_desc,
          context: context,
          alignCenter: true,
          type: "bodySecondary",
        ),
        AppSizedBox.height12,
        ContainerFormat(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          setState(
                            () => _switchValues[index] = !_switchValues[index],
                          );
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: isSelected ? 1.0 : 0.4,
                                child: _sensorIcons[index],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: TextFormat(
                                  text: titles[index],
                                  context: context,
                                  type: isSelected ? "body" : "bodySecondary",
                                  alignCenter: true,
                                ),
                              ),
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
            type: "bodySecondary",
          ),
          AppSizedBox.height12,
          ContainerListTile(
            title: context.l10n.umbrales_capacidad,
            subtitle: "${_depositCapacity.toInt()} L",
            subsubtitle: context.l10n.comun_rango("100000", "0", "L"),
            icon: AppIcon.deposit,
            onTap: () => ValueDialog.show(
              context: context,
              title: context.l10n.umbrales_capacidad,
              valueDefault: _depositCapacity,
              min: 0,
              max: 100000,
              unit: "L",
              onSaved: (val) => setState(() => _depositCapacity = val),
            ),
          ),
          AppSizedBox.height12,
          ContainerListTile(
            title: context.l10n.umbrales_altura,
            subtitle: "${_depositHeight.toInt()} CM",
            subsubtitle: context.l10n.comun_rango("1000", "0", "CM"),
            icon: AppIcon.heightOutlined,
            onTap: () => ValueDialog.show(
              context: context,
              title: context.l10n.umbrales_altura,
              valueDefault: _depositHeight,
              min: 0,
              max: 1000,
              unit: "CM",
              onSaved: (val) => setState(() => _depositHeight = val),
            ),
          ),
          AppSizedBox.height12,
          ContainerListTile(
            title: context.l10n.umbrales_espacio_sensor,
            subtitle: "${_fillGap.toInt()} CM",
            subsubtitle: context.l10n.comun_rango("100", "0", "CM"),
            icon: AppIcon.straightenOutlined,
            onTap: () => ValueDialog.show(
              context: context,
              title: context.l10n.umbrales_espacio_sensor,
              description: context.l10n.umbrales_espacio_sensor_desc,
              valueDefault: _fillGap,
              min: 0,
              max: 100,
              unit: "CM",
              illustration: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/espacioSensor.webp",
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              onSaved: (val) => setState(() => _fillGap = val),
            ),
          ),
        ],

        AppSizedBox.height12,

        // Ubicación del depósito
        TextFormat(
          text: context.l10n.ubicacion_deposito,
          context: context,
          type: "subtitle",
        ),
        TextFormat(
          text: context.l10n.deposito_ubicacion_desc,
          context: context,
          alignCenter: true,
          type: "bodySecondary",
        ),
        AppSizedBox.height12,
        ContainerFormat(
          children: [
            Padding(
              padding: AppPadding.symmetric0_8,
              child: Row(
                children: [
                  const IconFormat(icon: AppIcon.locationOnOutlined),
                  AppSizedBox.width8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormat(
                          text: _latitude != null && _longitude != null
                              ? "${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}"
                              : context.l10n.ubicacion_no_disponible,
                          context: context,
                          type: "body",
                        ),
                        AppSizedBox.height8,
                        TextFormat(
                          text: _latitude != null && _longitude != null
                              ? context.l10n.ubicacion_configurada
                              : context.l10n.deposito_sin_ubicacion,
                          context: context,
                          type: "bodySecondary",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSizedBox.height8,
            Align(
              alignment: Alignment.centerRight,
              child: ButtonFormat(
                type: "text",
                isLoading: _isGettingLocation,
                label: _latitude != null
                    ? context.l10n.ubicacion_actualizar
                    : context.l10n.ubicacion_obtener,
                onConfirm: _getCurrentLocation,
              ),
            ),
          ],
        ),

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
            type: "bodySecondary",
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
          isLoading: context.watch<DepositProvider>().isLoading,
        ),
      ],
    );
  }
}
