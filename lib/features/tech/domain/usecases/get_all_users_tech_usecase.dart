import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/tech/domain/entities/tech_user_summary.dart';
import 'package:aqua_steward/features/tech/domain/repositories/tech_repository_interface.dart';

class GetAllUsersTechUseCase {
  final ITechRepository repository;
  GetAllUsersTechUseCase(this.repository);

  Future<Result<List<TechUserSummary>>> call({required String token}) {
    return repository.getAllUsers(token: token);
  }
}
