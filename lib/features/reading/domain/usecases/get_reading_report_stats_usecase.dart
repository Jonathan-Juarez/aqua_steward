import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/reading/domain/entities/report_stats.dart';
import 'package:aqua_steward/features/reading/domain/repositories/reading_repository_interface.dart';

class GetReadingReportStatsUseCase {
  final IReadingRepository repository;

  GetReadingReportStatsUseCase(this.repository);

  Future<Result<ReportStats>> call({
    required String depositId,
    required String token,
    required String filter,
  }) async {
    return await repository.getReportStats(
      depositId: depositId,
      token: token,
      filter: filter,
    );
  }
}
