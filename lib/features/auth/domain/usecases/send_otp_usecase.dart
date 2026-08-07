import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/domain/repositories/otp_repository_interface.dart';

class SendOtpUseCase {
  final OtpRepositoryInterface _repository;

  SendOtpUseCase(this._repository);

  Future<Result<void>> call({required String email}) async {
    if (email.trim().isEmpty) {
      return Result.failure("El correo electrónico no puede estar vacío");
    }
    return await _repository.sendOtp(email: email);
  }
}
