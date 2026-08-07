import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/tech/data/sources/tech_data_source.dart';
import 'package:aqua_steward/features/tech/domain/entities/system_stats.dart';
import 'package:aqua_steward/features/tech/domain/entities/tech_user_summary.dart';
import 'package:aqua_steward/features/tech/domain/repositories/tech_repository_interface.dart';

class TechRepositoryImpl implements ITechRepository {
  final ITechDataSource dataSource;
  TechRepositoryImpl(this.dataSource);

  @override
  Future<Result<SystemStats>> getSystemStats({required String token}) async {
    final result = await dataSource.getSystemStats(token: token);
    if (result.isSuccess) {
      return Result.success(SystemStats.fromMap(result.data!));
    } else {
      return Result.failure(result.error);
    }
  }

  @override
  Future<Result<List<TechUserSummary>>> getAllUsers({
    required String token,
  }) async {
    final result = await dataSource.getAllUsers(token: token);
    if (result.isSuccess) {
      final list = result.data!
          .map((item) => TechUserSummary.fromMap(item as Map<String, dynamic>))
          .toList();
      return Result.success(list);
    } else {
      return Result.failure(result.error);
    }
  }
}
