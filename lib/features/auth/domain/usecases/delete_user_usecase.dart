import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/domain/repositories/auth_repository_interface.dart';

class DeleteUserUseCase {
  final IAuthRepository Irepository;

  DeleteUserUseCase(this.Irepository);

  Future<Result<void>> call({required String email}) {
    return Irepository.deleteUser(email: email);
  }
}
