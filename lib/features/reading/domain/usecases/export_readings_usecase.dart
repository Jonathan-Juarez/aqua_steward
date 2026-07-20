import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/reading/domain/entities/export_reading.dart';
import 'package:aqua_steward/features/reading/domain/repositories/reading_repository_interface.dart';

class ExportReadingsUseCase {
  final IReadingRepository repository;

  ExportReadingsUseCase(this.repository);

  Future<Result<List<ExportReading>>> call({
    required String depositId,
    required List<String> sensorTypes,
    required String token,
    required String filter,
  }) async {
    return await repository.exportReadings(
      depositId: depositId,
      sensorTypes: sensorTypes,
      token: token,
      filter: filter,
    );
  }
}
