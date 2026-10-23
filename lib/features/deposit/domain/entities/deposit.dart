import 'package:aqua_steward/features/deposit/domain/entities/sensor.dart';

class Deposit {
  final String? id, name, ip, owner_id, role;
  final double? capacity, installation_height, fill_gap;
  final double? latitude, longitude;
  final List<Sensor>? sensors;

  const Deposit({
    this.id,
    this.name,
    this.ip,
    this.capacity,
    this.installation_height,
    this.fill_gap,
    this.latitude,
    this.longitude,
    this.owner_id,
    this.role,
    this.sensors,
  });

  // Indica si el depósito tiene coordenadas almacenadas distintas de cero.
  bool get hasValidCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude != 0.0 &&
      longitude != 0.0;

  // Busca el sensor configurado según su tipo.
  Sensor? sensorOfType(String type) {
    for (final sensor in sensors ?? const <Sensor>[]) {
      if (sensor.type == type) return sensor;
    }
    return null;
  }

  // Un sensor sin configuración o sin estado definido se considera activo.
  bool isSensorActive(String type) {
    final state = sensorOfType(type)?.state;
    return state is bool ? state : true;
  }

  // Tipos de sensor activos, en el orden de SensorTypes.
  List<String> get activeSensorTypes => [
    for (final type in SensorTypes.all)
      if (isSensorActive(type)) type,
  ];
}
