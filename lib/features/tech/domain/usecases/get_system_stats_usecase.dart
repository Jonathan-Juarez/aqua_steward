import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/tech/domain/entities/system_stats.dart';
import 'package:aqua_steward/features/tech/domain/repositories/tech_repository_interface.dart';

class GetSystemStatsUseCase {
  final ITechRepository repository;
  GetSystemStatsUseCase(this.repository);

  Future<Result<SystemStats>> call({required String token}) {
    return repository.getSystemStats(token: token);
  }
}
