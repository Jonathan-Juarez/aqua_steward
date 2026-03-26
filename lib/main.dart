import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_theme.dart';
import 'package:aqua_steward/core/theme/theme_provider.dart';
import 'package:aqua_steward/features/auth/data/datasources/auth_data_source.dart';
import 'package:aqua_steward/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:aqua_steward/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:aqua_steward/features/auth/presentation/providers/reset_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Se inicializa Flutter antes de acceder a plugins nativos como SharedPreferences.
  WidgetsFlutterBinding.ensureInitialized();
  // Se carga el tema guardado antes de arrancar la app.
  final ThemeProvider savedTheme = await ThemeProvider.load();
  runApp(MainApp(savedTheme: savedTheme));
}

class MainApp extends StatelessWidget {
  final ThemeProvider savedTheme;
  const MainApp({super.key, required this.savedTheme});

  @override
  Widget build(BuildContext context) {
    //Para saber la ruta actual en la app
    // String? currentPath = ModalRoute.of(context)?.settings.name;
    // debugPrint(currentPath);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: savedTheme),
        ChangeNotifierProvider(
          create: (_) => ResetPasswordProvider(
            resetPasswordUseCase: ResetPasswordUseCase(
              AuthRepositoryImpl(AuthDataSourceImpl()),
            ),
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          // Define el nombre de la app al abrir aplicaciones recientes.
          title: "AquaSteward",
          //Desactiva el banner de depuración.
          debugShowCheckedModeBanner: false,
          // Temas de la app.
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // Modo de tema actual de la app.
          themeMode: themeProvider.themeMode,
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
