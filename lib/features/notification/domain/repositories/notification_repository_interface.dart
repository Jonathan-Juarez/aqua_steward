import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/notification/domain/entities/notification.dart';

abstract class NotificationRepositoryInterface {
  /// Registra el token FCM del dispositivo en el backend.
  Future<Result<void>> registerToken({required String fcmToken, required String authToken});

  /// Remueve el token FCM del dispositivo del backend.
  Future<Result<void>> unregisterToken({required String fcmToken, required String authToken});

  /// Obtiene la lista de notificaciones del usuario.
  Future<Result<List<Notification>>> getNotifications({required String token});

  /// Elimina una notificación específica.
  Future<Result<void>> deleteNotification({required String notificationId, required String token});

  /// Elimina todas las notificaciones del usuario.
  Future<Result<void>> deleteAllNotifications({required String token});

  /// Marca todas las notificaciones activas del usuario como leídas (inactivas).
  Future<Result<void>> markNotificationsAsRead({required String token});
}
