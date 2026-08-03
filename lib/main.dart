import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/services/session_service.dart';
import 'package:aqua_steward/core/theme/app_theme.dart';
import 'package:aqua_steward/core/providers/language_provider.dart';
import 'package:aqua_steward/core/providers/theme_provider.dart';
import 'package:aqua_steward/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:aqua_steward/l10n/app_localizations.dart';
import "package:aqua_steward/core/router/imports.dart";

// Firebase y Notificaciones
import 'package:firebase_core/firebase_core.dart';
import 'package:aqua_steward/firebase_options.dart';
import 'package:aqua_steward/core/services/notification_service.dart';
import 'package:aqua_steward/features/notification/data/sources/notification_remote_data_source.dart';
import 'package:aqua_steward/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:aqua_steward/features/notification/domain/usecases/register_fcm_token_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/unregister_fcm_token_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/delete_all_notifications_usecase.dart';
import 'package:aqua_steward/features/notification/domain/usecases/mark_notifications_as_read_usecase.dart';
import 'package:aqua_steward/features/notification/presentation/providers/notification_provider.dart';

// Variables globales para almacenar la información del paquete.
late PackageInfo packageInfo;

Future<void> main() async {
  // Se inicializa Flutter antes de acceder a plugins nativos.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializar Notificaciones
  await NotificationService.instance.initialize();

  packageInfo = await PackageInfo.fromPlatform();
  final (theme, language) = await (
    ThemeProvider.load(),
    LanguageProvider.load(),
  ).wait;

  // Verificación de sesión previa antes de lanzar la interfaz
  final authDataSource = AuthDataSource();
  final authRepository = AuthRepositoryImpl(authDataSource);
  final authProvider = AuthProvider(
    signinUseCase: SigninUseCase(authRepository),
    signupUseCase: SignupUseCase(authRepository),
    updateUserUseCase: UpdateUserUseCase(authRepository),
    resetPasswordUseCase: ResetPasswordUseCase(authRepository),
    deleteUserUseCase: DeleteUserUseCase(authRepository),
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
  final ThemeProvider savedTheme;
  final LanguageProvider savedLanguage;
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
            );
          },
        ),
      ],
      // Se consume el tema y el idioma para configurar la app.
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, _) => MaterialApp(
          // Permite controlar naveación desde cualquier parte sin BuildContext.
          navigatorKey: SessionService.navigatorKey,
          // Define el nombre de la app al abrir aplicaciones recientes.
          title: "AquaSteward",
          //Desactiva el banner de depuración.
          debugShowCheckedModeBanner: false,
          // Temas de la app.
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // Modo de tema actual de la app.
          themeMode: themeProvider.themeMode,

          // Se usa el idioma configurado.
          locale: languageProvider.locale,
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
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
