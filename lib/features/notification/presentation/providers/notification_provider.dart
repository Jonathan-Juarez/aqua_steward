import 'dart:async';
import 'package:flutter/material.dart' hide Notification;
import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/services/notification_service.dart';
import 'package:aqua_steward/features/notification/domain/entities/notification.dart';
import 'package:aqua_steward/features/notification/domain/usecases/register_fcm_token_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/unregister_fcm_token_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/delete_all_notifications_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/mark_notifications_as_read_usecase.dart';

class NotificationProvider extends ChangeNotifier {
  final RegisterFCMTokenUseCase _registerFCMTokenUseCase;
  final UnregisterFCMTokenUseCase _unregisterFCMTokenUseCase;
  final GetNotificationsUseCase _getNotificationsUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final DeleteAllNotificationsUseCase _deleteAllNotificationsUseCase;
  final MarkNotificationsAsReadUseCase _markNotificationsAsReadUseCase;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  List<Notification> _notifications = [];
  List<Notification> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((n) => n.state == 'activa').length;
  bool get hasUnreadNotifications => unreadCount > 0;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription? _messageSubscription;
  String? _currentAuthToken;

  final String Function()? readToken;
  final VoidCallback? onMessageReceived;

  NotificationProvider({
    required RegisterFCMTokenUseCase registerFCMTokenUseCase,
    required UnregisterFCMTokenUseCase unregisterFCMTokenUseCase,
    required GetNotificationsUseCase getNotificationsUseCase,
    required DeleteNotificationUseCase deleteNotificationUseCase,
    required DeleteAllNotificationsUseCase deleteAllNotificationsUseCase,
    required MarkNotificationsAsReadUseCase markNotificationsAsReadUseCase,
    this.readToken,
    this.onMessageReceived,
  }) : _registerFCMTokenUseCase = registerFCMTokenUseCase,
       _unregisterFCMTokenUseCase = unregisterFCMTokenUseCase,
       _getNotificationsUseCase = getNotificationsUseCase,
       _deleteNotificationUseCase = deleteNotificationUseCase,
       _deleteAllNotificationsUseCase = deleteAllNotificationsUseCase,
       _markNotificationsAsReadUseCase = markNotificationsAsReadUseCase;

  // Inicializa la escucha de refresco de tokens FCM y registra el token actual si hay sesión activa.
  Future<void> init([String? authToken]) async {
    _currentAuthToken = authToken ?? readToken?.call();

    // Solicita permisos de notificación al sistema
    await NotificationService.instance.requestPermissions();

    // Obtener token inicial
    final token = await NotificationService.instance.getToken();
    _fcmToken = token;
    notifyListeners();

    if (_fcmToken != null &&
        _currentAuthToken != null &&
        _currentAuthToken!.isNotEmpty) {
      await registerToken(_fcmToken!, _currentAuthToken!);
      await fetchNotifications(_currentAuthToken!);
    }

    // Cancelar suscripción previa si existe
    await _tokenRefreshSubscription?.cancel();
    await _messageSubscription?.cancel();

    // Escuchar cambios dinámicos del token FCM
    _tokenRefreshSubscription = NotificationService.instance.onTokenRefresh
        .listen((newToken) async {
          _fcmToken = newToken;
          notifyListeners();
          final effectiveToken = _currentAuthToken ?? readToken?.call();
          if (effectiveToken != null && effectiveToken.isNotEmpty) {
            await registerToken(newToken, effectiveToken);
          }
        });

    // Escuchar llegada de notificaciones en tiempo real para refrescar la lista y el contador
    _messageSubscription = NotificationService.instance.onMessageReceived
        .listen((_) async {
          final effectiveToken = _currentAuthToken ?? readToken?.call();
          if (effectiveToken != null && effectiveToken.isNotEmpty) {
            await fetchNotifications(effectiveToken);
          }
          onMessageReceived?.call();
        });
  }

  // Obtiene la lista de notificaciones desde la API.
  Future<Result<void>> fetchNotifications([String? token]) async {
    final effectiveToken = token ?? _currentAuthToken ?? readToken?.call() ?? "";
    _currentAuthToken = effectiveToken;
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _getNotificationsUseCase(token: effectiveToken);
      if (result.isSuccess) {
        _notifications = result.data ?? [];
      }
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Marca las notificaciones activas como leídas/inactivas (todas o una específica).
  Future<Result<void>> markNotificationsAsRead({
    String? token,
    String? notificationId,
  }) async {
    final effectiveToken = token ?? _currentAuthToken ?? readToken?.call() ?? "";
    final result = await _markNotificationsAsReadUseCase(
      token: effectiveToken,
      notificationId: notificationId,
    );
    if (result.isSuccess) {
      _notifications = _notifications.map((n) {
        if (notificationId != null && n.id != notificationId) {
          return n;
        }
        return Notification(
          id: n.id,
          title: n.title,
          message: n.message,
          type: n.type,
          date: n.date,
          state: 'inactiva',
          depositId: n.depositId,
        );
      }).toList();
      notifyListeners();
    }
    return result;
  }

  // Elimina una notificación por ID.
  Future<Result<void>> deleteNotification(
    String notificationId, [
    String? token,
  ]) async {
    final effectiveToken = token ?? _currentAuthToken ?? readToken?.call() ?? "";
    final result = await _deleteNotificationUseCase(
      notificationId: notificationId,
      token: effectiveToken,
    );
    if (result.isSuccess) {
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    }
    return result;
  }

  // Elimina todas las notificaciones del usuario.
  Future<Result<void>> deleteAllNotifications([String? token]) async {
    final effectiveToken = token ?? _currentAuthToken ?? readToken?.call() ?? "";
    final result = await _deleteAllNotificationsUseCase(token: effectiveToken);
    if (result.isSuccess) {
      _notifications.clear();
      notifyListeners();
    }
    return result;
  }

  // Registra el token FCM actual en el servidor backend.
  Future<Result<void>> registerToken(String fcmToken, [String? authToken]) async {
    final effectiveToken =
        authToken ?? _currentAuthToken ?? readToken?.call() ?? "";
    final result = await _registerFCMTokenUseCase(
      fcmToken: fcmToken,
      authToken: effectiveToken,
    );
    return result;
  }

  // Elimina el token FCM del servidor backend.
  Future<Result<void>> unregisterToken(
    String fcmToken, [
    String? authToken,
  ]) async {
    final effectiveToken =
        authToken ?? _currentAuthToken ?? readToken?.call() ?? "";
    final result = await _unregisterFCMTokenUseCase(
      fcmToken: fcmToken,
      authToken: effectiveToken,
    );
    return result;
  }

  // Limpia la suscripción activa al cerrar sesión.
  Future<void> cleanup([String? authToken]) async {
    final effectiveToken =
        authToken ?? _currentAuthToken ?? readToken?.call() ?? "";
    _fcmToken ??= await NotificationService.instance.getToken();
    if (_fcmToken != null && effectiveToken.isNotEmpty) {
      await unregisterToken(_fcmToken!, effectiveToken);
    }
    await _tokenRefreshSubscription?.cancel();
    await _messageSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _messageSubscription = null;
    _currentAuthToken = null;
    _notifications.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _messageSubscription?.cancel();
    super.dispose();
  }
}
