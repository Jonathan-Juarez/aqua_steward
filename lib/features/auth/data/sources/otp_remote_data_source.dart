import "package:aqua_steward/core/error/result.dart";
import "package:aqua_steward/core/network/api_client.dart";

// Data Source de autenticación y verificación de código OTP mediante el servidor AquaSteward.
class OtpRemoteDataSource {
  // Solicita el envío del código OTP a través del proxy del servidor AquaSteward.
  Future<Result<void>> sendOtp({required String email}) =>
      ApiClient.post("/api/auth/send-otp", body: {"email": email.trim()});

  // Solicita la verificación del código OTP a través del proxy del servidor AquaSteward.
  Future<Result<bool>> verifyOtp({
    required String email,
    required String otp,
  }) => ApiClient.post(
    "/api/auth/verify-otp",
    body: {"email": email.trim(), "otp": otp.trim()},
    // Se valida que el resultado sea correcto (true).
    fromJson: (data) => (data as Map<String, dynamic>)["verified"] == true,
  );
}
