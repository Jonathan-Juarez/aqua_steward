import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

/// Handler de mensajes en segundo plano. Debe ser una función global y estar anotada con @pragma('vm:entry-point').
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Mensaje recibido en segundo plano: ${message.messageId}");
  }
}

class NotificationService {
  // Constructor privado del patrón Singleton para evitar instanciaciones externas.
  NotificationService._internal();

  // Instancia única y global del servicio accesible desde cualquier punto de la aplicación.
  static final NotificationService instance = NotificationService._internal();

  // Cliente del SDK de Firebase Messaging encargado de la comunicación con la nube.
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Plugin encargado de renderizar y mostrar notificaciones locales flotantes en primer plano.
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // StreamController broadcast para transmitir notificaciones recibidas en tiempo real dentro del estado de la app.
  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();

  // Stream público expuesto para escuchar la llegada de notificaciones en primer plano.
  Stream<RemoteMessage> get onMessageReceived =>
      _messageStreamController.stream;

  // Canal de notificaciones para Android (alta importancia)
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'Notificaciones de Alta Importancia', // title
    description:
        'Este canal se usa para notificaciones importantes del sistema.', // description
    importance: Importance.max,
  );

  /// Inicializa los servicios de notificaciones (Firebase Messaging y Notificaciones Locales).
  Future<void> initialize() async {
    // Configura el handler de segundo plano
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Inicialización de Notificaciones Locales para Android e iOS
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Crear el canal de notificaciones en Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Configurar la escucha de mensajes en primer plano (Foreground)
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Configurar la escucha al hacer clic en una notificación cuando la app está en segundo plano o cerrada
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Manejar el caso de que la app se abra desde una notificación terminada
    final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data);
    }
  }

  /// Solicita de forma activa los permisos de notificación.
  Future<bool> requestPermissions() async {
    final NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Obtiene el token de FCM del dispositivo.
  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      if (kDebugMode) {
        print("Error obteniendo el token de FCM: $e");
      }
      return null;
    }
  }

  /// Stream para escuchar el refresco del FCM Token.
  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  /// Maneja los mensajes recibidos en primer plano (Foreground).
  void _onForegroundMessage(RemoteMessage message) {
    _messageStreamController.add(message);
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android.smallIcon ?? '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  /// Maneja el evento de click en una notificación push de FCM.
  void _onMessageOpenedApp(RemoteMessage message) {
    _handleNotificationClick(message.data);
  }

  /// Maneja el click en una notificación local.
  void _onDidReceiveNotificationResponse(NotificationResponse details) {
    if (details.payload != null) {
      // Aquí se puede procesar el payload de la notificación local.
    }
  }

  /// Redirige o realiza acciones en base a los datos adjuntos de la notificación.
  void _handleNotificationClick(Map<String, dynamic> data) {
    if (kDebugMode) {
      print("Notificación cliqueada con datos: $data");
    }
  }
}
