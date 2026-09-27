import 'package:aqua_steward/features/reading/domain/entities/export_reading.dart';

class ExportReadingModel extends ExportReading {
  ExportReadingModel({
    required super.timestamp,
    required super.value,
    required super.unit,
    required super.sensorType,
    required super.depositName,
  });

  factory ExportReadingModel.fromJson(Map<String, dynamic> json) {
    return ExportReadingModel(
      timestamp: DateTime.parse(json['timestamp'].toString()),
      value: (json['value'] as num).toDouble(),
      unit: json['unit']?.toString() ?? '',
      sensorType: json['sensorType']?.toString() ?? '',
      depositName: json['depositName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'unit': unit,
      'sensorType': sensorType,
      'depositName': depositName,
    };
  }
}
