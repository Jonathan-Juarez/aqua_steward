class ExportReading {
  final DateTime timestamp;
  final double value;
  final String unit;
  final String sensorType;
  final String depositName;

  ExportReading({
    required this.timestamp,
    required this.value,
    required this.unit,
    required this.sensorType,
    required this.depositName,
  });
}
