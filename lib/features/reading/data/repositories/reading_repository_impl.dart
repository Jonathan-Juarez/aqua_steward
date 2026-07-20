import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/reading/data/sources/reading_data_source.dart';
import 'package:aqua_steward/features/reading/domain/entities/reading.dart';
import 'package:aqua_steward/features/reading/domain/entities/export_reading.dart';
import 'package:aqua_steward/features/reading/domain/repositories/reading_repository_interface.dart';

class ReadingRepositoryImpl implements IReadingRepository {
  final IReadingDataSource dataSource;

  ReadingRepositoryImpl(this.dataSource);

  @override
  Future<Result<List<Reading>>> getReadings({
    required String depositId,
    required String sensorType,
    required String token,
    required String filter,
  }) async {
    return await dataSource.getReadings(
      depositId: depositId,
      sensorType: sensorType,
      token: token,
      filter: filter,
    );
  }

  @override
  Future<Result<List<ExportReading>>> exportReadings({
    required String depositId,
    required List<String> sensorTypes,
    required String token,
    required String filter,
  }) async {
    return await dataSource.exportReadings(
      depositId: depositId,
      sensorTypes: sensorTypes,
      token: token,
      filter: filter,
    );
  }
}
