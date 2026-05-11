import "dart:typed_data";
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

  // Monitoreo
  static const String dashboard = "/dashboard";
  static const String parametersDetails = "/parameters-details";
  static const String registers = "/registers";

  // Gestión de usuarios
  static const String profile = "/profile";
  static const String members = "/members";

  // Depósitos
  static const String addDeposit = "/add_deposit";
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

    forgotPassword: (context) => const ForgotPassword(),
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

    // Monitoring (Dashboard y Detalles)
    dashboard: (context) => const DashboardScreen(),
    //Parameters Details es la fusión de Registers y Reports.
    // parametersDetails: (context) {
    //   // Recibe como argumentos los datos del depósito y el parámetro inicial.
    //   final args =
    //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //   return ParametersDetailsScreen(
    //     initialParameter: args["initialParameter"] as String,
    //     depositData: args["depositData"] as Map<String, dynamic>,
    //   );
    // },
    registers: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return RegistersScreen(
        initialParameter: args["initialParameter"] as String,
        depositData: args["depositData"] as Map<String, dynamic>,
      );
    },

    // Gestión de usuarios
    profile: (context) => const ProfileScreen(),
    members: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return MembersScreen(depositId: args["depositId"] as String);
    },

    // Depósitos
    addDeposit: (context) {
      // Soporta crear (sin args) y editar (con args).
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return AddDepositScreen(
        depositData: args?["depositData"] as Map<String, dynamic>?,
      );
    },
    settingsThreshold: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return SettingsThresholdScreen(
        depositData: args["depositData"] as Map<String, dynamic>,
      );
    },
    scanner: (context) => const ScannerScreen(),

    // Alertas
    alerts: (context) => const AlertsScreen(),

    // Reportes
    generateReports: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Uint8List?;
      return GenerateReportsScreen(chartImage: args);
    },
    pdfPreview: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return PdfScreen(dataPdf: args);
    },
    // Manejar CalendarStartEnd como un showDatePicker o un Dialog Modal.

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
