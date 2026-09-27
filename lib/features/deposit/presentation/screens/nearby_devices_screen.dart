import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/services/network_discovery_service.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class NearbyDevicesScreen extends StatefulWidget {
  const NearbyDevicesScreen({super.key});

  @override
  State<NearbyDevicesScreen> createState() => _NearbyDevicesScreenState();
}

class _NearbyDevicesScreenState extends State<NearbyDevicesScreen> {
  bool _isScanning = true;
  List<DiscoveredDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    _scanDevices();
  }

  Future<void> _scanDevices() async {
    setState(() {
      _isScanning = true;
      _devices = [];
    });

    final found = await NetworkDiscoveryService.discoverDevices();

    if (mounted) {
      setState(() {
        _devices = found;
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_dispositivos_cercanos,
      children: [
        Padding(
          padding: AppPadding.all16,
          child: Column(
            children: [
              // Estado 1: Escaneando la red
              if (_isScanning)
                ContainerFormat(
                  children: [
                    AppIcon.wifiFind(size: 50),
                    AppSizedBox.height12,
                    TextFormat(
                      context: context,
                      text: context.l10n.dispositivos_buscando,
                      type: "titleSmall",
                      alignCenter: true,
                    ),
                    AppSizedBox.height8,
                    TextFormat(
                      context: context,
                      text: context.l10n.dispositivos_ayuda_red,
                      type: "body",
                      alignCenter: true,
                    ),
                  ],
                ),

              // Estado 2: Escaneo finalizado sin resultados
              if (!_isScanning && _devices.isEmpty)
                ContainerFormat(
                  children: [
                    AppIcon.wifiOff(size: 50),
                    AppSizedBox.height12,
                    TextFormat(
                      context: context,
                      text: context.l10n.dispositivos_no_encontrados,
                      type: "titleSmall",
                      alignCenter: true,
                    ),
                    AppSizedBox.height8,
                    TextFormat(
                      context: context,
                      text: context.l10n.dispositivos_ayuda_red,
                      type: "body",
                      alignCenter: true,
                    ),
                    AppSizedBox.height12,
                    ButtonFormat(
                      label: context.l10n.dispositivos_reintentar,
                      onConfirm: _scanDevices,
                    ),
                  ],
                ),

              // Estado 3: Dispositivos encontrados
              if (!_isScanning && _devices.isNotEmpty) ...[
                TextFormat(
                  context: context,
                  text: context.l10n.dispositivos_ayuda_red,
                  type: "body",
                  alignCenter: true,
                ),
                AppSizedBox.height12,
                for (final device in _devices)
                  Padding(
                    padding: AppPadding.bottom16,
                    child: ContainerListTile(
                      onTap: () => Navigator.pop(context, device.macAddress),
                      icon: AppIcon.sensors,
                      title: device.name,
                      subtitle: "MAC: ${device.macAddress}",
                    ),
                  ),
                ButtonFormat(
                  label: context.l10n.dispositivos_reintentar,
                  onConfirm: _scanDevices,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
