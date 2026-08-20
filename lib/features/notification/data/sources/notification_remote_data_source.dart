import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/api_client.dart';
import 'package:aqua_steward/features/notification/data/models/notification_model.dart';

abstract class INotificationRemoteDataSource {
  Future<Result<void>> registerToken({
    required String fcmToken,
    required String authToken,
  });
  Future<Result<void>> unregisterToken({
    required String fcmToken,
    required String authToken,
  });
  Future<Result<List<NotificationModel>>> getNotifications({
    required String token,
  });
  Future<Result<void>> deleteNotification({
    required String notificationId,
    required String token,
  });
  Future<Result<void>> deleteAllNotifications({required String token});
  Future<Result<void>> markNotificationsAsRead({
    required String token,
    String? notificationId,
  });
}

class NotificationRemoteDataSource implements INotificationRemoteDataSource {
  @override
  Future<Result<void>> registerToken({
    required String fcmToken,
    required String authToken,
  }) => ApiClient.post(
    '/api/notifications/register',
    token: authToken,
    body: {'fcmToken': fcmToken},
  );

  @override
  Future<Result<void>> unregisterToken({
    required String fcmToken,
    required String authToken,
  }) => ApiClient.post(
    '/api/notifications/unregister',
    token: authToken,
    body: {'fcmToken': fcmToken},
  );

  @override
  Future<Result<List<NotificationModel>>> getNotifications({
    required String token,
  }) => ApiClient.get(
    '/api/notifications/getNotifications',
    token: token,
    fromJson: (data) =>
        (data as List).map((item) => NotificationModel.fromMap(item)).toList(),
  );

  @override
  Future<Result<void>> deleteNotification({
    required String notificationId,
    required String token,
  }) => ApiClient.delete(
    '/api/notifications/deleteNotification/$notificationId',
    token: token,
  );

  @override
  Future<Result<void>> deleteAllNotifications({required String token}) =>
      ApiClient.delete(
        '/api/notifications/deleteAllNotifications',
        token: token,
      );

  @override
  Future<Result<void>> markNotificationsAsRead({
    required String token,
    String? notificationId,
  }) => ApiClient.put(
    '/api/notifications/markAsRead',
    token: token,
    body: {'notificationId': notificationId},
  );
}
