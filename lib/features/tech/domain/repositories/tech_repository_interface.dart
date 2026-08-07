import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/tech/domain/entities/system_stats.dart';
import 'package:aqua_steward/features/tech/domain/entities/tech_user_summary.dart';

abstract class ITechRepository {
  Future<Result<SystemStats>> getSystemStats({required String token});
  Future<Result<List<TechUserSummary>>> getAllUsers({required String token});
}
