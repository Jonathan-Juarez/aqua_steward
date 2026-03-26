import 'package:aqua_steward/core/router/app_navigator.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:flutter/material.dart';

// Buscar todos los colores para el modo claro.
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: AppColor.black,
      ),
      titleMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColor.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColor.black,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: AppColor.black),
      bodySmall: TextStyle(fontSize: 16, color: AppColor.blackSecondary),
      labelLarge: TextStyle(fontSize: 14, color: AppColor.black),
      labelMedium: TextStyle(fontSize: 14, color: AppColor.blackSecondary),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColor.white,
      secondary: AppColor.containerContrastLight,
      tertiary: AppColor.success,
      onSurface: AppColor.black,
      onSurfaceVariant: AppColor.blackSecondary,
      inversePrimary: AppColor.inactiveLight,
      error: AppColor.error,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: AppNavigator(),
        TargetPlatform.iOS: AppNavigator(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.containerContrast,
      iconTheme: IconThemeData(color: AppColor.white),
      titleTextStyle: TextStyle(
        color: AppColor.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColor.backgroundLight,
    iconTheme: const IconThemeData(color: AppColor.black),
    dividerColor: Colors.transparent,

    bottomAppBarTheme: const BottomAppBarThemeData(
      color: AppColor.containerContrast,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.containerContrast,
      foregroundColor: AppColor.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColor.containerContrast,
      contentTextStyle: TextStyle(color: AppColor.white),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize: 16,
        color: AppColor.black,
        fontWeight: FontWeight.w400,
      ),
      floatingLabelStyle: TextStyle(
        color: AppColor.black,
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.black),
        borderRadius: AppBorder.all8,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.black),
        borderRadius: AppBorder.all8,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.success),
        borderRadius: AppBorder.all8,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.error),
        borderRadius: AppBorder.all8,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.error, width: 2),
        borderRadius: AppBorder.all8,
      ),
      prefixIconColor: AppColor.black,
      suffixIconColor: AppColor.black,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      circularTrackColor: AppColor.inactiveLight,
      linearTrackColor: AppColor.inactiveLight,
    ),
    sliderTheme: const SliderThemeData(
      inactiveTrackColor: AppColor.inactiveLight,
      activeTrackColor: AppColor.containerContrast,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.backgroundLight,
      shape: RoundedRectangleBorder(borderRadius: AppBorder.all8),
    ),
    dividerTheme: const DividerThemeData(color: Colors.black12),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.success, // Color del cursor.
      selectionColor: AppColor.success.withOpacity(
        0.2,
      ), // Color de fondo del texto seleccionado.
      selectionHandleColor: AppColor.success, // Color de las bolitas.
    ),
  );

  // Tema oscuro para la app.
  static ThemeData darkTheme = ThemeData(
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
      ),
      titleMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: AppColor.white),
      bodySmall: TextStyle(fontSize: 16, color: AppColor.whiteSecondary),
      labelLarge: TextStyle(fontSize: 14, color: AppColor.white),
      labelMedium: TextStyle(fontSize: 14, color: AppColor.whiteSecondary),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColor.container,
      secondary: AppColor.containerContrast,
      tertiary: AppColor.success,
      onSurface: AppColor.white,
      onSurfaceVariant: AppColor.whiteSecondary,
      inversePrimary: AppColor.inactive,
      error: AppColor.error,
    ),

    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: AppNavigator(),
        TargetPlatform.iOS: AppNavigator(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.containerContrast,
      iconTheme: IconThemeData(color: AppColor.white),
      foregroundColor: AppColor.white,
      titleTextStyle: TextStyle(
        color: AppColor.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColor.background,
    iconTheme: const IconThemeData(color: AppColor.white),
    dividerColor: Colors.transparent,

    bottomAppBarTheme: const BottomAppBarThemeData(
      color: AppColor.containerContrast,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.containerContrast,
      foregroundColor: AppColor.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColor.containerContrast,
      contentTextStyle: TextStyle(color: AppColor.white),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize: 16,
        color: AppColor.white,
        fontWeight: FontWeight.w400,
      ),
      floatingLabelStyle: TextStyle(
        color: AppColor.white,
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.white),
        borderRadius: AppBorder.all8,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.white),
        borderRadius: AppBorder.all8,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.success),
        borderRadius: AppBorder.all8,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.error),
        borderRadius: AppBorder.all8,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.error, width: 2),
        borderRadius: AppBorder.all8,
      ),
      prefixIconColor: AppColor.white,
      suffixIconColor: AppColor.white,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      circularTrackColor: AppColor.inactive,
      linearTrackColor: AppColor.inactive,
    ),
    sliderTheme: const SliderThemeData(
      inactiveTrackColor: AppColor.inactive,
      activeTrackColor: AppColor.containerContrast,
      thumbColor: AppColor.white,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.background,
      shape: RoundedRectangleBorder(borderRadius: AppBorder.all8),
    ),
    dividerTheme: const DividerThemeData(color: Colors.white12),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.success, // Color del cursor.
      selectionColor: AppColor.success.withOpacity(
        0.2,
      ), // Color de fondo del texto seleccionado.
      selectionHandleColor: AppColor.success, // Color de las bolitas.
    ),
  );
}
