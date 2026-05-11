import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/reading/domain/entities/reading.dart';

abstract class IReadingRepository {
  Future<Result<List<Reading>>> getReadings({
    required String depositId,
    required String sensorType,
    required String token,
    required String filter,
  });
}
