import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:aqua_steward/core/router/imports.dart";

class AppRouter {
  // Inicio de las rutas constantes.
  static const String start = "/";
  //Auth
  static const String signup = "/signup";
  static const String signin = "/signin";
  static const String resetPassword = "/reset_password";
  static const String forgotPassword = "/forgot_password";
  static const String confirmationReset = "/confirmation_reset";
  static const String confirmationSignup = "/confirmation_signup";

  // Navegación entre dashboard y perfil.
  static const String mainNavigation = "/main_navigation";

  // Gestión de usuarios
  static const String members = "/members";

  // Depósitos
  static const String addDeposit = "/add_deposit";
  static const String depositScreen = "/deposit_screen";
  static const String settingsThreshold = "/settings_threshold";
  static const String scanner = "/scanner";

  // Alertas
  static const String alerts = "/alerts";

  // Reportes
  static const String generateReports = "/generate_reports";
  static const String pdfPreview = "/pdf_preview";

  // Soporte
  static const String support = "/support";
  static const String contact = "/contact";
  static const String userManual = "/user_manual";
  static const String about = "/about";

  //Rutas del sistema.
  static Map<String, WidgetBuilder> routes = {
    start: (context) => const StartScreen(),
    // Auth
    signup: (context) => const SignupScreen(),
    signin: (context) => const SigninScreen(),
    resetPassword: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ResetPasswordScreen(email: args["email"] as String);
    },

    forgotPassword: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ForgotPassword(email: args["email"] as String);
    },
    confirmationReset: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ConfirmationScreen(
        screen: AppRouter.resetPassword,
        email: args["email"] as String,
      );
    },
    confirmationSignup: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ConfirmationScreen(
        screen: AppRouter.signin,
        email: args["email"] as String,
      );
    },

    // Navegación Principal
    mainNavigation: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return MainNavigationScreen(
        switchValues: args?["switchValues"] as Map<String, dynamic>?,
      );
    },

    // Gestión de usuarios
    members: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return MembersScreen(depositId: args["depositId"] as String);
    },

    // Depósitos
    depositScreen: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return DepositScreen(
        depositData: args?["depositData"] as Map<String, dynamic>?,
      );
    },
    scanner: (context) => const ScannerScreen(),

    // Alertas
    alerts: (context) => const NotificationScreen(),

    // Reportes
    generateReports: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return ReportsScreen(
        depositData: args?["depositData"] as Map<String, dynamic>?,
      );
    },
    pdfPreview: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return PdfScreen(dataPdf: args);
    },

    // Soporte
    support: (context) => const SupportScreen(),
    contact: (context) => ChangeNotifierProvider(
      create: (_) => ContactProvider(
        sendEmailUsecase: SendEmailUsecase(
          ContactRepositoryImpl(ContactLauncherSource()),
        ),
      ),
      child: const ContactScreen(),
    ),
    userManual: (context) => const UserManualScreen(),
    about: (context) => const AboutScreen(),
  };
}
