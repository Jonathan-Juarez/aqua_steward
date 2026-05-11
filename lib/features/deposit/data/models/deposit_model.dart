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
      "owner_id": owner_id,
      "role": role,
      "sensors": sensors?.map((s) => (s as SensorModel).toMap()).toList(),
    };
    if (id != null && id!.isNotEmpty) {
      map["_id"] = id; // Mongoose usa _id
    }
    return map;
  }

  String toJson() => json.encode(toMap());

  factory DepositModel.fromMap(Map<String, dynamic> map) {
    return DepositModel(
      id: (map["id"] ?? map["_id"]) as String? ?? "",
      name: map["name"] as String? ?? "",
      ip: map["ip"] as String? ?? "",
      capacity: (map["capacity"] as num?)?.toDouble() ?? 0,
      installation_height:
          (map["installation_height"] as num?)?.toDouble() ?? 0,
      fill_gap: (map["fill_gap"] as num?)?.toDouble() ?? 0,
      owner_id: map["owner_id"] as String? ?? "",
      role: map["role"] as String?,
      sensors: (map["sensors"] as List<dynamic>?)
          ?.map((s) => SensorModel.fromMap(s as Map<String, dynamic>))
          .toList(),
    );
  }

  factory DepositModel.fromJson(String source) =>
      DepositModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
