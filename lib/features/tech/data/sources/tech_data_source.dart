import 'dart:convert';
import 'package:aqua_steward/core/error/exception_handler.dart';
import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/global_variable.dart';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:http/http.dart' as http;

abstract class ITechDataSource {
  Future<Result<Map<String, dynamic>>> getSystemStats({required String token});
  Future<Result<List<dynamic>>> getAllUsers({required String token});
}

class TechDataSourceImpl implements ITechDataSource {
  @override
  Future<Result<Map<String, dynamic>>> getSystemStats({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$uri/api/tech/stats"),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      final res = manageHttpResponse(response: response);
      if (res.isSuccess) {
        return Result.success(json.decode(response.body));
      } else {
        return Result.failure(res.error);
      }
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Result<List<dynamic>>> getAllUsers({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse("$uri/api/tech/users"),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      final res = manageHttpResponse(response: response);
      if (res.isSuccess) {
        return Result.success(json.decode(response.body));
      } else {
        return Result.failure(res.error);
      }
    } catch (e) {
      return handleException(e);
    }
  }
}
