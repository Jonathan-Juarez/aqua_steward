import 'dart:convert';

class Deposit {
  final String? id, name, ip, owner_id;
  final int? capacity;
  final double? installation_height, fill_gap;
  final List<dynamic>? sensors;

  const Deposit({
    this.id,
    this.name,
    this.ip,
    this.capacity,
    this.installation_height,
    this.fill_gap,
    this.owner_id,
    this.sensors,
  });

  Map<String, dynamic> depositToMap() {
    Map<String, dynamic> map = {
      "name": name,
      "ip": ip,
      "capacity": capacity,
      "installation_height": installation_height,
      "fill_gap": fill_gap,
      "owner_id": owner_id,
      "sensors": sensors,
    };
    if (id != null && id!.isNotEmpty) {
      map["_id"] = id; // Mongoose usa _id
    }
    return map;
  }

  String depositToJson() => json.encode(depositToMap());

  factory Deposit.fromMap(Map<String, dynamic> map) {
    return Deposit(
      id: (map["id"] ?? map["_id"]) as String? ?? "",
      name: map["name"] as String? ?? "",
      ip: map["ip"] as String? ?? "",
      capacity: map["capacity"] as int? ?? 0,
      installation_height:
          (map["installation_height"] as num?)?.toDouble() ?? 0.0,
      fill_gap: (map["fill_gap"] as num?)?.toDouble() ?? 0.0,
      owner_id: map["owner_id"] as String? ?? "",
      sensors: map["sensors"] as List<dynamic>?,
    );
  }

  factory Deposit.fromJson(String source) =>
      Deposit.fromMap(json.decode(source) as Map<String, dynamic>);
}
