import 'package:aqua_steward/features/reading/domain/entities/reading.dart';

class ReadingModel extends Reading {
  ReadingModel({super.hour, super.day, required super.value});

  factory ReadingModel.fromJson(Map<String, dynamic> json) {
    return ReadingModel(
      hour: json['hour'] != null ? (json['hour'] as num).toInt() : null,
      day: json['day'] != null ? (json['day'] as num).toInt() : null,
      value: (json['value'] as num).toDouble(),
    );
  }
}
