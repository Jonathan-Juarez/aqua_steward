import 'dart:convert';
import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/global_variable.dart';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:aqua_steward/core/error/exception_handler.dart';
import 'package:aqua_steward/features/notification/data/models/notification_model.dart';
import 'package:http/http.dart' as http;

abstract class NotificationRemoteDataSourceInterface {
  Future<Result<void>> registerToken({required String fcmToken, required String authToken});
  Future<Result<void>> unregisterToken({required String fcmToken, required String authToken});
  Future<Result<List<NotificationModel>>> getNotifications({required String token});
  Future<Result<void>> deleteNotification({required String notificationId, required String token});
  Future<Result<void>> deleteAllNotifications({required String token});
  Future<Result<void>> markNotificationsAsRead({required String token});
}

class NotificationRemoteDataSource implements NotificationRemoteDataSourceInterface {
  @override
  Future<Result<void>> registerToken({
    required String fcmToken,
    required String authToken,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("$uri/api/notifications/register"),
        body: json.encode({"fcmToken": fcmToken}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": authToken,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Result<void>> unregisterToken({
    required String fcmToken,
    required String authToken,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("$uri/api/notifications/unregister"),
        body: json.encode({"fcmToken": fcmToken}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": authToken,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Result<List<NotificationModel>>> getNotifications({required String token}) async {
    try {
      final http.Response response = await http.get(
        Uri.parse("$uri/api/notifications/getNotifications"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      final result = manageHttpResponse(response: response);
      if (result.isSuccess) {
        final List<dynamic> body = json.decode(response.body);
        final notifications = body.map((item) => NotificationModel.fromMap(item)).toList();
        return Result.success(notifications);
      } else {
        return Result.failure(result.error);
      }
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Result<void>> deleteNotification({
    required String notificationId,
    required String token,
  }) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse("$uri/api/notifications/deleteNotification/$notificationId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Result<void>> deleteAllNotifications({required String token}) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse("$uri/api/notifications/deleteAllNotifications"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Result<void>> markNotificationsAsRead({required String token}) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("$uri/api/notifications/read"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }
}
