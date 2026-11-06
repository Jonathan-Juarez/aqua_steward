import 'package:aqua_steward/core/network/network_validator.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/storage/session_storage.dart';
import 'package:aqua_steward/core/theme/app_theme.dart';
import 'package:aqua_steward/core/storage/language_storage.dart';
import 'package:aqua_steward/core/storage/theme_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:aqua_steward/l10n/app_localizations.dart';
import 'package:aqua_steward/core/router/imports.dart';

// Firebase y Notificaciones
import 'package:firebase_core/firebase_core.dart';
import 'package:aqua_steward/firebase_options.dart';
import 'package:aqua_steward/core/services/notification_service.dart';

// Variables globales para almacenar la información del paquete.
late PackageInfo packageInfo;

Future<void> main() async {
  // Se inicializa Flutter antes de acceder a plugins nativos.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase y el servicio de notificaciones.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.initialize();

  // Carga de información del sistema y preferencias guardadas.
  packageInfo = await PackageInfo.fromPlatform();
  final (theme, language) = await (
    ThemeStorage.load(),
    LanguageStorage.load(),
  ).wait;

  // Verificación de sesión previa antes de lanzar la interfaz
  final authDataSource = AuthDataSource();
  final authRepository = AuthRepositoryImpl(authDataSource);
  final otpRemoteDataSource = OtpRemoteDataSource();
  final otpRepository = OtpRepositoryImpl(otpRemoteDataSource);

  final authProvider = AuthProvider(
    signinUseCase: SigninUseCase(authRepository),
    signupUseCase: SignupUseCase(authRepository),
    updateUserUseCase: UpdateUserUseCase(authRepository),
    resetPasswordUseCase: ResetPasswordUseCase(authRepository),
    deleteUserUseCase: DeleteUserUseCase(authRepository),
    sendOtpUseCase: SendOtpUseCase(otpRepository),
    verifyOtpUseCase: VerifyOtpUseCase(otpRepository),
  );

  final isLoggedIn = await authProvider.tryAutoLogin();
  final initialRoute = isLoggedIn ? AppRouter.mainNavigation : AppRouter.start;

  runApp(
    MainApp(
      savedTheme: theme,
      savedLanguage: language,
      savedAuthProvider: authProvider,
      initialRoute: initialRoute,
    ),
  );
}

class MainApp extends StatefulWidget {
  final ThemeStorage savedTheme;
  final LanguageStorage savedLanguage;
  final AuthProvider savedAuthProvider;
  final String initialRoute;

  const MainApp({
    super.key,
    required this.savedTheme,
    required this.savedLanguage,
    required this.savedAuthProvider,
    required this.initialRoute,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final DepositProvider _depositProvider;
  late final ReadingProvider _readingProvider;
  late final TeamProvider _teamProvider;
  late final NotificationProvider _notificationProvider;
  VoidCallback? _authListener;

  @override
  void initState() {
    super.initState();

    final depositDataSource = DepositDataSourceImpl();
    final depositRepository = DepositRepositoryImpl(depositDataSource);
    _depositProvider = DepositProvider(
      getDepositsUseCase: GetDepositsUseCase(depositRepository),
      createDepositUseCase: CreateDepositUseCase(depositRepository),
      deleteDepositUseCase: DeleteDepositUseCase(depositRepository),
      updateDepositUseCase: UpdateDepositUsecase(repository: depositRepository),
      readToken: () => widget.savedAuthProvider.currentUser?.token ?? "",
    );

    final readingDataSource = ReadingDataSourceImpl();
    final readingRepository = ReadingRepositoryImpl(readingDataSource);
    final getReadingsUseCase = GetReadingsUseCase(readingRepository);
    _readingProvider = ReadingProvider(
      getReadingsUseCase: getReadingsUseCase,
      exportReadingsUseCase: ExportReadingsUseCase(readingRepository),
      getReportStatsUseCase: GetReadingReportStatsUseCase(readingRepository),
      readToken: () => widget.savedAuthProvider.currentUser?.token ?? "",
    );

    final teamDataSource = TeamDataSourceImpl();
    final teamRepository = TeamRepositoryImpl(teamDataSource);
    _teamProvider = TeamProvider(
      getMembersUseCase: GetMembersUseCase(teamRepository),
      inviteMemberUseCase: InviteMemberUseCase(teamRepository),
      deleteMemberUseCase: DeleteMemberUseCase(teamRepository),
      updateMemberUseCase: UpdateMemberUseCase(teamRepository),
      getInvitationsUseCase: GetInvitationsUseCase(teamRepository),
      acceptInvitationUseCase: AcceptInvitationUseCase(teamRepository),
      rejectInvitationUseCase: RejectInvitationUseCase(teamRepository),
      leaveDepositUseCase: LeaveDepositUseCase(teamRepository),
      readToken: () => widget.savedAuthProvider.currentUser?.token ?? "",
    );

    final notifDataSource = NotificationRemoteDataSource();
    final notifRepository = NotificationRepositoryImpl(notifDataSource);
    _notificationProvider = NotificationProvider(
      registerFCMTokenUseCase: RegisterFCMTokenUseCase(notifRepository),
      unregisterFCMTokenUseCase: UnregisterFCMTokenUseCase(notifRepository),
      getNotificationsUseCase: GetNotificationsUseCase(notifRepository),
      deleteNotificationUseCase: DeleteNotificationUseCase(notifRepository),
      deleteAllNotificationsUseCase: DeleteAllNotificationsUseCase(
        notifRepository,
      ),
      markNotificationsAsReadUseCase: MarkNotificationsAsReadUseCase(
        notifRepository,
      ),
      readToken: () => widget.savedAuthProvider.currentUser?.token ?? "",
      onMessageReceived: () {
        _depositProvider.getDeposits();
        _teamProvider.getInvitations();
      },
    );

    // Si ya existe sesión activa, inicializa el servicio de notificaciones
    if (widget.savedAuthProvider.currentUser?.token != null) {
      _notificationProvider.init();
    }

    // Sincroniza el registro de notificaciones al cambiar el estado de autenticación
    _authListener = () {
      final token = widget.savedAuthProvider.currentUser?.token;
      if (token != null && token.isNotEmpty) {
        _notificationProvider.init(token);
      }
    };
    widget.savedAuthProvider.addListener(_authListener!);
  }

  @override
  void dispose() {
    if (_authListener != null) {
      widget.savedAuthProvider.removeListener(_authListener!);
    }
    _depositProvider.dispose();
    _readingProvider.dispose();
    _teamProvider.dispose();
    _notificationProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.savedTheme),
        ChangeNotifierProvider.value(value: widget.savedLanguage),
        ChangeNotifierProvider.value(value: widget.savedAuthProvider),
        ChangeNotifierProvider.value(value: _notificationProvider),
        ChangeNotifierProvider.value(value: _depositProvider),
        ChangeNotifierProvider.value(value: _readingProvider),
        ChangeNotifierProvider.value(value: _teamProvider),
      ],
      // Se consume el tema y el idioma para configurar la app.
      child: Consumer2<ThemeStorage, LanguageStorage>(
        builder: (context, themeStorage, languageStorage, _) => MaterialApp(
          // Permite controlar naveación desde cualquier parte sin BuildContext.
          navigatorKey: SessionStorage.navigatorKey,
          // Define el nombre de la app al abrir aplicaciones recientes.
          title: "AquaSteward",
          //Desactiva el banner de depuración.
          debugShowCheckedModeBanner: false,
          // Temas de la app.
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // Modo de tema actual de la app.
          themeMode: themeStorage.themeMode,

          // Se usa el idioma configurado.
          locale: languageStorage.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,

          initialRoute: widget.initialRoute,
          routes: AppRouter.routes,
          // Se limita el escalado de texto globalmente sin reconstruir MaterialApp al abrir teclado.
          builder: (context, child) {
            final query = MediaQuery.of(context);
            return MediaQuery(
              data: query.copyWith(
                textScaler: query.textScaler.clamp(
                  minScaleFactor: 0.8,
                  maxScaleFactor: 1.15,
                ),
              ),
              child: NetworkValidator(screen: child!),
            );
          },
        ),
      ),
    );
  }
}
