import 'dart:async';
import 'package:multicast_dns/multicast_dns.dart';

// Representa un kit AquaSteward descubierto en la red local.
class DiscoveredDevice {
  final String name;
  final String macAddress; // MAC Address extraída del hostname mDNS
  final String ip;
  final int? port;

  const DiscoveredDevice({
    required this.name,
    required this.macAddress,
    required this.ip,
    this.port,
  });
}

// Servicio encargado del encontrar kits en la red Wi-Fi local mediante el protocolo estándar mDNS (Multicast DNS / Zeroconf).
class NetworkDiscoveryService {
  static const String _serviceType = '_aquasteward._tcp.local';

  // Extrae la MAC del hostname mDNS del ESP32.
  // El hostname tiene el formato: "aquasteward-a4cf1289b012.local"
  // Se extrae "a4cf1289b012" y se formatea como "A4:CF:12:89:B0:12"
  static String? _extractMacFromHostname(String hostname) {
    final lower = hostname.toLowerCase().replaceAll('.local', '');
    if (!lower.startsWith('aquasteward-')) return null;

    final macHex = lower.replaceFirst('aquasteward-', '');
    if (macHex.length != 12) return null;
    if (!RegExp(r'^[0-9a-f]{12}$').hasMatch(macHex)) return null;

    // Formatear como XX:XX:XX:XX:XX:XX
    final buffer = StringBuffer();
    for (int i = 0; i < 12; i += 2) {
      if (i > 0) buffer.write(':');
      buffer.write(macHex.substring(i, i + 2).toUpperCase());
    }
    return buffer.toString();
  }

  // Escanea la red local en busca de kits anunciados vía mDNS.
  static Future<List<DiscoveredDevice>> discoverDevices({
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final List<DiscoveredDevice> devices = [];
    final MDnsClient client = MDnsClient();

    try {
      await client.start();

      // Consulta PTR para el tipo de servicio _aquasteward._tcp.local
      final ptrStream = client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(_serviceType),
      );

      final ptrFuture = () async {
        await for (final PtrResourceRecord ptr in ptrStream) {
          final srvStream = client.lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(ptr.domainName),
          );

          await for (final SrvResourceRecord srv in srvStream) {
            // Extrae la MAC del hostname del SRV (ej: aquasteward-a4cf1289b012.local)
            final mac = _extractMacFromHostname(srv.target);
            if (mac == null) continue;

            final ipStream = client.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(srv.target),
            );

            await for (final IPAddressResourceRecord ip in ipStream) {
              final cleanIp = ip.address.address;

              if (!devices.any((d) => d.macAddress == mac)) {
                devices.add(
                  DiscoveredDevice(
                    name: 'AquaSteward Kit',
                    macAddress: mac,
                    ip: cleanIp,
                    port: srv.port,
                  ),
                );
              }
            }
          }
        }
      }();

      // Esperar los descubrimientos o agotar el tiempo límite
      await Future.any([
        ptrFuture,
        Future.delayed(timeout),
      ]);
    } catch (_) {
      // Retorna los dispositivos encontrados hasta el momento
    } finally {
      client.stop();
    }

    return devices;
  }
}
