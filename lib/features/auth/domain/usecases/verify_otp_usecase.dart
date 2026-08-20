import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/domain/repositories/otp_repository_interface.dart';

class VerifyOtpUseCase {
  final OtpRepositoryInterface _repository;

  VerifyOtpUseCase(this._repository);

  Future<Result<bool>> call({
    required String email,
    required String otp,
  }) async {
    return await _repository.verifyOtp(email: email, otp: otp);
  }
}
