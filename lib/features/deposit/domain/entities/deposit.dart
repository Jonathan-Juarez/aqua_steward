import 'package:aqua_steward/features/deposit/domain/entities/sensor.dart';

class Deposit {
  final String? id, name, ip, owner_id, role;
  final double? capacity, installation_height, fill_gap;
  final List<Sensor>? sensors;

  const Deposit({
    this.id,
    this.name,
    this.ip,
    this.capacity,
    this.installation_height,
    this.fill_gap,
    this.owner_id,
    this.role,
    this.sensors,
  });
}
