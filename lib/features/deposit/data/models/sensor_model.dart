import 'package:aqua_steward/features/deposit/domain/entities/sensor.dart';

class SensorModel extends Sensor {
  const SensorModel({
    super.type,
    super.state,
    super.unit,
    super.minValue,
    super.maxValue,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "state": state,
      "unit": unit,
      // Solo se envía si tiene valor, ya que el sensor de turbidez no tiene.
      if (minValue != null) "min_value": minValue,
      "max_value": maxValue,
    };
  }

  factory SensorModel.fromMap(Map<String, dynamic> map) {
    return SensorModel(
      type: map["type"]?.toString(),
      state: map["state"],
      unit: map["unit"]?.toString(),
      minValue: (map["min_value"] as num?)?.toDouble(),
      maxValue: (map["max_value"] as num?)?.toDouble(),
    );
  }
}
