import 'package:aqua_steward/core/error/result.dart';

abstract class OtpRepositoryInterface {
  Future<Result<void>> sendOtp({required String email});
  Future<Result<bool>> verifyOtp({
    required String email,
    required String otp,
  });
}
