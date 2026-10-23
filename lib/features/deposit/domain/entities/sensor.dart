// Tipos de sensor soportados, en el orden: nivel, pH y turbidez.
class SensorTypes {
  static const String level = "HC-SR04";
  static const String ph = "PH-4502C";
  static const String turbidity = "TS300B";
  static const List<String> all = [level, ph, turbidity];
}

class Sensor {
  final String? type;
  final dynamic state;
  final String? unit;
  final double? minValue;
  final double? maxValue;

  const Sensor({
    this.type,
    this.state,
    this.unit,
    this.minValue,
    this.maxValue,
  });
}
