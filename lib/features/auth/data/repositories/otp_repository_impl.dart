import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/data/sources/otp_remote_data_source.dart';
import 'package:aqua_steward/features/auth/domain/repositories/otp_repository_interface.dart';

class OtpRepositoryImpl implements OtpRepositoryInterface {
  final OtpRemoteDataSource _remoteDataSource;

  OtpRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<void>> sendOtp({required String email}) async {
    return await _remoteDataSource.sendOtp(email: email);
  }

  @override
  Future<Result<bool>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _remoteDataSource.verifyOtp(email: email, otp: otp);
  }
}
