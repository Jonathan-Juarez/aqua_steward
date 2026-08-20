import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/domain/repositories/otp_repository_interface.dart';

class SendOtpUseCase {
  final OtpRepositoryInterface _repository;

  SendOtpUseCase(this._repository);

  Future<Result<void>> call({required String email}) async {
    return await _repository.sendOtp(email: email);
  }
}
