import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/reading/domain/entities/reading.dart';
import 'package:aqua_steward/features/reading/domain/repositories/reading_repository_interface.dart';

class GetReadingsUseCase {
  final IReadingRepository repository;

  GetReadingsUseCase(this.repository);

  Future<Result<List<Reading>>> call({
    required String depositId,
    required String sensorType,
    required String token,
    required String filter,
  }) async {
    // Se llama al repositorio para obtener el contrato de lectura.
    return await repository.getReadings(
      depositId: depositId,
      sensorType: sensorType,
      token: token,
      filter: filter,
    );
  }
}
