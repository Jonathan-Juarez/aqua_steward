import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_theme.dart';
import 'package:aqua_steward/core/providers/language_provider.dart';
import 'package:aqua_steward/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:aqua_steward/l10n/app_localizations.dart';
import "package:aqua_steward/core/router/imports.dart";

// Variables globales para almacenar la información del paquete.
late PackageInfo packageInfo;

Future<void> main() async {
  // Se inicializa Flutter antes de acceder a plugins nativos.
  WidgetsFlutterBinding.ensureInitialized();

  packageInfo = await PackageInfo.fromPlatform();
  final (theme, language) = await (
    ThemeProvider.load(),
    LanguageProvider.load(),
  ).wait;
  runApp(MainApp(savedTheme: theme, savedLanguage: language));
}

class MainApp extends StatelessWidget {
  final ThemeProvider savedTheme;
  final LanguageProvider savedLanguage;
  const MainApp({
    super.key,
    required this.savedTheme,
    required this.savedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: savedTheme),
        ChangeNotifierProvider.value(value: savedLanguage),
        // AuthProvider ahora gestiona tanto la sesión como el perfil del usuario (AuthProvider unificado).
        ChangeNotifierProvider(
          create: (_) {
            final authDataSource = AuthDataSource();
            final authRepository = AuthRepositoryImpl(authDataSource);

            return AuthProvider(
              signinUseCase: SigninUseCase(authRepository),
              signupUseCase: SignupUseCase(authRepository),
              updateUserUseCase: UpdateUserUseCase(authRepository),
              resetPasswordUseCase: ResetPasswordUseCase(authRepository),
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

          initialRoute: '/',
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
