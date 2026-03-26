import "package:aqua_steward/features/alerts/presentation/screens/alerts_screen.dart";
import "package:aqua_steward/features/auth/presentation/screens/confirmation_screen.dart";
import "package:aqua_steward/features/auth/presentation/screens/forgot_password_screen.dart";
import "package:aqua_steward/features/auth/presentation/screens/reset_password.dart";
import "package:aqua_steward/features/auth/presentation/screens/start_screen.dart";
import "package:aqua_steward/features/auth/presentation/screens/signin_screen.dart";
import "package:aqua_steward/features/auth/presentation/screens/signup_screen.dart";
import "package:aqua_steward/features/profile/presentation/screens/members_screen.dart";
import "package:aqua_steward/features/reports/presentation/screens/add_deposit_screen.dart";
import "package:aqua_steward/features/reports/presentation/screens/generate_reports_screen.dart";
import "package:aqua_steward/features/monitoring/presentation/screens/parameters_details_screen.dart";
import "package:aqua_steward/features/reports/presentation/screens/settings_threshold_screen.dart";
import "package:aqua_steward/features/support/presentation/screens/contact_screen.dart";
import "package:aqua_steward/features/support/presentation/screens/support_screen.dart";
import "package:aqua_steward/features/monitoring/presentation/screens/dashborad_screen.dart";
import "package:aqua_steward/features/profile/presentation/screens/profile_screen.dart";
import "package:aqua_steward/features/support/presentation/screens/user_manual.dart";
import "package:flutter/material.dart";

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

  // Gestión de usuarios
  static const String profile = "/profile";
  static const String members = "/members";

  // Depósitos
  static const String addDeposit = "/add_deposit";
  static const String settingsThreshold = "/settings_threshold";

  // Alertas
  static const String alerts = "/alerts";

  // Reportes
  static const String generateReports = "/generate_reports";

  // Soporte
  static const String support = "/support";
  static const String contact = "/contact";
  static const String userManual = "/user_manual";

  //Rutas del sistema.
  static Map<String, WidgetBuilder> routes = {
    start: (context) => const StartScreen(),
    // Auth
    signup: (context) => const SignupScreen(),
    signin: (context) => const SigninScreen(),
    resetPassword: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ResetPasword(email: args["email"] as String);
    },

    forgotPassword: (context) => const ForgotPasword(),
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
    parametersDetails: (context) {
      // Recibe como argumentos los datos del depósito y el parámetro inicial.
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ParametersDetailsScreen(
        initialParameter: args["initialParameter"] as String,
        depositData: args["depositData"] as Map<String, dynamic>,
      );
    },

    // Gestión de usuarios
    profile: (context) => const ProfileScreen(),
    members: (context) => const MembersScreen(),

    // Depósitos
    addDeposit: (context) => const AddDepositScreen(),
    settingsThreshold: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return SettingsThresholdScreen(
        depositData: args["depositData"] as Map<String, dynamic>,
      );
    },

    // Alertas
    alerts: (context) => const AlertsScreen(),

    // Reportes
    generateReports: (context) => const GenerateReportsScreen(),
    // Manejar CalendarStartEnd como un showDatePicker o un Dialog Modal.

    // Soporte
    support: (context) => const SupportScreen(),
    contact: (context) => const ContactScreen(),
    userManual: (context) => const UserManualScreen(),
  };
}
