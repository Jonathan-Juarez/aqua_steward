import 'package:aqua_steward/core/router/app_navigator.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:flutter/material.dart';

// Buscar todos los colores para el modo claro.
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: const TextTheme(
      // Usado para las iniciales del perfil y la cantidad de recurso en los detalles de cada parámetro.
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColor.black,
      ),
      // Usado para los títulos principales de las secciones.
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColor.black,
      ),
      // Usado para los subtítulos de las secciones.
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColor.black,
      ),
      // Usado para el el cuerpo del texto.
      bodyLarge: TextStyle(fontSize: 16, color: AppColor.black),
      // Usado para el cuerpo del texto secundario (usado en FAQ).
      bodyMedium: TextStyle(fontSize: 16, color: AppColor.blackSecondary),
      // Usado para textos debajo del cuerpo.
      bodySmall: TextStyle(fontSize: 14, color: AppColor.blackSecondary),
      // Usado para las etiquetas de los gráficos.
      labelMedium: TextStyle(fontSize: 10, color: AppColor.black),
    ),

    colorScheme: const ColorScheme.light(
      // Para los contendores.
      primary: AppColor.white,
      // Para textos principales.
      onSurface: AppColor.black,
      // Para textos secundarios.
      onSurfaceVariant: AppColor.blackSecondary,
      // Para textos inactivos.
      inversePrimary: AppColor.inactiveLight,
      // Para errores.
      error: AppColor.error,
    ),

    datePickerTheme: DatePickerThemeData(
      // Configuraciones Generales del DatePicker
      backgroundColor: AppColor.white,
      headerBackgroundColor: AppColor.containerContrast,
      headerForegroundColor: AppColor.white,

      // Configuraciones específicas del DateRangePicker
      rangePickerHeaderBackgroundColor: AppColor.containerContrast,
      rangePickerHeaderForegroundColor: AppColor.white,
      // Tamaño de la fecha seleccionada en el menú superior ("Ene 12 - Ene 15")
      rangePickerHeaderHeadlineStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
      ),
      // Tamaño del texto de ayuda superior ("Select range" o traducido)
      rangePickerHeaderHelpStyle: const TextStyle(
        fontSize: 16,
        color: AppColor.white,
        fontWeight: FontWeight.bold,
      ),
      // Color intermedio de los días en un rango: del 12 al 15 (el 13 y 14)
      rangeSelectionBackgroundColor: AppColor.success.withOpacity(0.2),

      // Estilos de los días interactivos del calendario
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColor.success;
        return Colors.transparent;
      }),
      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColor.white;
        if (states.contains(MaterialState.disabled)) {
          return AppColor.inactiveLight;
        }
        return AppColor.black;
      }),
      todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColor.success;
        return Colors.transparent;
      }),
      todayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColor.white;
        return AppColor.success;
      }),
    ),

    switchTheme: SwitchThemeData(
      // Color del botón (pulgar) del switch.
      thumbColor: MaterialStateProperty.all(AppColor.white),
      // Color del fondo del switch.
      trackColor: MaterialStateProperty.all(AppColor.containerContrast),
      // Color del borde del switch.
      trackOutlineColor: MaterialStateProperty.all(AppColor.inactiveLight),
    ),

    // Botones.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: AppText.button,
        backgroundColor: AppColor.containerContrast,
        foregroundColor: AppColor.white,
        shape: const RoundedRectangleBorder(borderRadius: AppBorder.all8),
        minimumSize: const Size(double.infinity, 45),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColor.black),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColor.black),
    ),

    listTileTheme: const ListTileThemeData(iconColor: AppColor.black),

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
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColor.backgroundLight,
    iconTheme: const IconThemeData(color: AppColor.black),

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
      color: AppColor.white,
    ),

    sliderTheme: const SliderThemeData(
      inactiveTrackColor: AppColor.inactiveLight,
      activeTrackColor: AppColor.containerContrast,
    ),

    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: AppBorder.all8),
    ),

    dividerTheme: const DividerThemeData(color: Colors.black12),
    dividerColor: Colors.transparent,

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
      // Usado para las iniciales del perfil y la cantidad de recurso en los detalles de cada parámetro.
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
      ),
      // Usado para los títulos principales de las secciones.
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
      ),
      // Usado para los subtítulos de las secciones.
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
      ),
      // Usado para el el cuerpo del texto.
      bodyLarge: TextStyle(fontSize: 16, color: AppColor.white),
      // Usado para el cuerpo del texto secundario.
      bodyMedium: TextStyle(fontSize: 16, color: AppColor.whiteSecondary),
      // Usado para textos debajo del cuerpo.
      bodySmall: TextStyle(fontSize: 14, color: AppColor.whiteSecondary),
      // Usado para las etiquetas de los gráficos.
      labelMedium: TextStyle(fontSize: 10, color: AppColor.white),
    ),

    colorScheme: const ColorScheme.dark(
      // Para los contenedores.
      primary: AppColor.container,
      // Para textos principales.
      onSurface: AppColor.white,
      // Para textos secundarios.
      onSurfaceVariant: AppColor.whiteSecondary,
      // Para textos inactivos.
      inversePrimary: AppColor.inactive,
      // Para errores.
      error: AppColor.error,
    ),

    datePickerTheme: DatePickerThemeData(
      // Configuraciones Generales del DatePicker
      backgroundColor: AppColor.container,
      headerBackgroundColor: AppColor.containerContrast,
      headerForegroundColor: AppColor.white,
      // Configuraciones específicas del DateRangePicker
      rangePickerHeaderBackgroundColor: AppColor.containerContrast,
      rangePickerHeaderForegroundColor: AppColor.white,
      // Tamaño de la fecha seleccionada en el menú superior ("Ene 12 - Ene 15")
      rangePickerHeaderHeadlineStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColor.white,
      ),
      // Tamaño del texto de ayuda superior (Seleccionar periodo).
      rangePickerHeaderHelpStyle: const TextStyle(
        fontSize: 16,
        color: AppColor.white,
        fontWeight: FontWeight.bold,
      ),
      // Color intermedio de los días en un rango: del 12 al 15 (el 13 y 14)
      rangeSelectionBackgroundColor: AppColor.success.withOpacity(0.2),

      // Estilos de los días interactivos del calendario
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColor.success;
        return Colors.transparent;
      }),
      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColor.white;
        if (states.contains(MaterialState.disabled)) return AppColor.inactive;
        return AppColor.white;
      }),
      todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColor.success;
        return Colors.transparent;
      }),
      todayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColor.white;
        return AppColor.success;
      }),
    ),

    switchTheme: SwitchThemeData(
      // Color del botón (pulgar) del switch.
      thumbColor: MaterialStateProperty.all(AppColor.white),
      // Color del fondo del switch.
      trackColor: MaterialStateProperty.all(AppColor.containerContrast),
      // Color del borde del switch.
      trackOutlineColor: MaterialStateProperty.all(AppColor.inactiveLight),
    ),

    // Botones.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: AppText.button,
        backgroundColor: AppColor.containerContrast,
        foregroundColor: AppColor.white,
        shape: const RoundedRectangleBorder(borderRadius: AppBorder.all8),
        minimumSize: const Size(double.infinity, 45),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColor.white),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColor.white),
    ),

    listTileTheme: const ListTileThemeData(iconColor: AppColor.white),

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
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColor.background,
    iconTheme: const IconThemeData(color: AppColor.white),

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
      color: AppColor.white,
    ),

    sliderTheme: const SliderThemeData(
      inactiveTrackColor: AppColor.inactive,
      activeTrackColor: AppColor.containerContrast,
      thumbColor: AppColor.white,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.container,
      shape: RoundedRectangleBorder(borderRadius: AppBorder.all8),
    ),

    dividerTheme: const DividerThemeData(color: Colors.white12),
    dividerColor: Colors.transparent,

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.success, // Color del cursor.
      selectionColor: AppColor.success.withOpacity(
        0.2,
      ), // Color de fondo del texto seleccionado.
      selectionHandleColor: AppColor.success, // Color de las bolitas.
    ),
  );
}
