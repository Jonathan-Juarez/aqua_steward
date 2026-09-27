import "dart:convert";
import "package:aqua_steward/features/deposit/domain/entities/deposit.dart";
import "package:aqua_steward/features/deposit/data/models/sensor_model.dart";

class DepositModel extends Deposit {
  const DepositModel({
    super.id,
    super.name,
    super.ip,
    super.capacity,
    super.installation_height,
    super.fill_gap,
    super.latitude,
    super.longitude,
    super.owner_id,
    super.role,
    super.sensors,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "ip": ip,
      "capacity": capacity,
      "installation_height": installation_height,
      "fill_gap": fill_gap,
      "latitude": latitude,
      "longitude": longitude,
      "owner_id": owner_id,
      "role": role,
      "sensors": sensors?.map((s) {
        if (s is SensorModel) return s.toMap();
        return {
          "type": s.type,
          "state": s.state,
          "unit": s.unit,
          "min_value": s.minValue,
          "max_value": s.maxValue,
        };
      }).toList(),
    };
    if (id != null && id!.isNotEmpty) {
      map["id"] = id;
    }
    return map;
  }

  String toJson() => json.encode(toMap());

  factory DepositModel.fromMap(Map<String, dynamic> map) {
    return DepositModel(
      id: (map["id"] ?? map["_id"])?.toString() ?? "",
      name: map["name"]?.toString() ?? "",
      ip: map["ip"]?.toString() ?? "",
      capacity: (map["capacity"] as num?)?.toDouble() ?? 0,
      installation_height:
          (map["installation_height"] as num?)?.toDouble() ?? 0,
      fill_gap: (map["fill_gap"] as num?)?.toDouble() ?? 0,
      latitude: (map["latitude"] as num?)?.toDouble(),
      longitude: (map["longitude"] as num?)?.toDouble(),
      owner_id: map["owner_id"]?.toString() ?? "",
      role: map["role"]?.toString(),
      sensors: (map["sensors"] as List<dynamic>?)
          ?.map((s) => SensorModel.fromMap(s as Map<String, dynamic>))
          .toList(),
    );
  }

  factory DepositModel.fromJson(String source) =>
      DepositModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory DepositModel.fromEntity(Deposit deposit) {
    return DepositModel(
      id: deposit.id,
      name: deposit.name,
      ip: deposit.ip,
      capacity: deposit.capacity,
      installation_height: deposit.installation_height,
      fill_gap: deposit.fill_gap,
      latitude: deposit.latitude,
      longitude: deposit.longitude,
      owner_id: deposit.owner_id,
      role: deposit.role,
      sensors: deposit.sensors?.map((s) {
        if (s is SensorModel) return s;
        return SensorModel(
          type: s.type,
          state: s.state,
          unit: s.unit,
          minValue: s.minValue,
          maxValue: s.maxValue,
        );
      }).toList(),
    );
  }
}
