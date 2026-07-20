import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/reading/domain/entities/reading.dart';
import 'package:aqua_steward/features/reading/domain/entities/export_reading.dart';

abstract class IReadingRepository {
  Future<Result<List<Reading>>> getReadings({
    required String depositId,
    required String sensorType,
    required String token,
    required String filter,
  });

  Future<Result<List<ExportReading>>> exportReadings({
    required String depositId,
    required List<String> sensorTypes,
    required String token,
    required String filter,
  });
}
