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
