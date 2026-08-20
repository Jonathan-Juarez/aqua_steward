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

class MainApp extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: savedTheme),
        ChangeNotifierProvider.value(value: savedLanguage),
        ChangeNotifierProvider.value(value: savedAuthProvider),
        // NotificationProvider para notificaciones push
        ChangeNotifierProvider(
          create: (_) {
            final remoteDataSource = NotificationRemoteDataSource();
            final repository = NotificationRepositoryImpl(remoteDataSource);
            return NotificationProvider(
              registerFCMTokenUseCase: RegisterFCMTokenUseCase(repository),
              unregisterFCMTokenUseCase: UnregisterFCMTokenUseCase(repository),
              getNotificationsUseCase: GetNotificationsUseCase(repository),
              deleteNotificationUseCase: DeleteNotificationUseCase(repository),
              deleteAllNotificationsUseCase: DeleteAllNotificationsUseCase(
                repository,
              ),
              markNotificationsAsReadUseCase: MarkNotificationsAsReadUseCase(
                repository,
              ),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dataSource = DepositDataSourceImpl();
            final repository = DepositRepositoryImpl(dataSource);
            return DepositProvider(
              getDepositsUseCase: GetDepositsUseCase(repository),
              createDepositUseCase: CreateDepositUseCase(repository),
              deleteDepositUseCase: DeleteDepositUseCase(repository),
              updateDepositUseCase: UpdateDepositUsecase(
                repository: repository,
              ),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dataSource = ReadingDataSourceImpl();
            final repository = ReadingRepositoryImpl(dataSource);
            return ReadingProvider(
              getReadingsUseCase: GetReadingsUseCase(repository),
              exportReadingsUseCase: ExportReadingsUseCase(repository),
              getReportStatsUseCase: GetReadingReportStatsUseCase(repository),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dataSource = TeamDataSourceImpl();
            final repository = TeamRepositoryImpl(dataSource);
            return TeamProvider(
              getMembersUseCase: GetMembersUseCase(repository),
              inviteMemberUseCase: InviteMemberUseCase(repository),
              deleteMemberUseCase: DeleteMemberUseCase(repository),
              updateMemberUseCase: UpdateMemberUseCase(repository),
              getInvitationsUseCase: GetInvitationsUseCase(repository),
              acceptInvitationUseCase: AcceptInvitationUseCase(repository),
              rejectInvitationUseCase: RejectInvitationUseCase(repository),
              leaveDepositUseCase: LeaveDepositUseCase(repository),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dataSource = TechDataSourceImpl();
            final repository = TechRepositoryImpl(dataSource);
            return TechProvider(
              getSystemStatsUseCase: GetSystemStatsUseCase(repository),
              getAllUsersTechUseCase: GetAllUsersTechUseCase(repository),
            );
          },
        ),
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

          initialRoute: initialRoute,
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
