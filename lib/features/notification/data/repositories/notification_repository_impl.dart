import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/notification/data/sources/notification_remote_data_source.dart';
import 'package:aqua_steward/features/notification/domain/entities/notification.dart';
import 'package:aqua_steward/features/notification/domain/repositories/notification_repository_interface.dart';

class NotificationRepositoryImpl implements NotificationRepositoryInterface {
  final NotificationRemoteDataSourceInterface _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<void>> registerToken({
    required String fcmToken,
    required String authToken,
  }) {
    return _remoteDataSource.registerToken(fcmToken: fcmToken, authToken: authToken);
  }

  @override
  Future<Result<void>> unregisterToken({
    required String fcmToken,
    required String authToken,
  }) {
    return _remoteDataSource.unregisterToken(fcmToken: fcmToken, authToken: authToken);
  }

  @override
  Future<Result<List<Notification>>> getNotifications({required String token}) {
    return _remoteDataSource.getNotifications(token: token);
  }

  @override
  Future<Result<void>> deleteNotification({required String notificationId, required String token}) {
    return _remoteDataSource.deleteNotification(notificationId: notificationId, token: token);
  }

  @override
  Future<Result<void>> deleteAllNotifications({required String token}) {
    return _remoteDataSource.deleteAllNotifications(token: token);
  }

  @override
  Future<Result<void>> markNotificationsAsRead({required String token}) {
    return _remoteDataSource.markNotificationsAsRead(token: token);
  }
}
