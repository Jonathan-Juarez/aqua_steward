import 'dart:convert';
import 'package:aqua_steward/core/error/exception_handler.dart';
import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/global_variable.dart';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:http/http.dart' as http;

// Data Source de autenticación y verificación de código OTP mediante el servidor AquaSteward.
class OtpRemoteDataSource {
  // Solicita el envío del código OTP a través del proxy del servidor AquaSteward.
  Future<Result<void>> sendOtp({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse("$uri/api/auth/send-otp"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: json.encode({"email": email.trim()}),
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }

  // Solicita la verificación del código OTP a través del proxy del servidor AquaSteward.
  Future<Result<bool>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$uri/api/auth/verify-otp"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: json.encode({"email": email.trim(), "otp": otp.trim()}),
      );

      final manageResult = manageHttpResponse(response: response);
      if (manageResult.isSuccess) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final isVerified = data["verified"] as bool? ?? false;
        return isVerified
            ? Result.success(true)
            : Result.failure(
                "El código ingresado es incorrecto o ha expirado.",
              );
      }

      return Result.failure(manageResult.error);
    } catch (e) {
      return handleException(e);
    }
  }
}
