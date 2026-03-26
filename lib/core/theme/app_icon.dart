import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppIcon {
  // Iconos de la pantalla de inicio.
  static const Icon notificationsOutlined = Icon(
    Icons.notifications_outlined,
    size: 24,
  );
  static const Icon supportOutline = Icon(Icons.help_outline, size: 24);
  static const Icon homeOutlined = Icon(
    Icons.home_outlined,
    color: AppColor.white,
    size: 20,
  );

  // Iconos de auth
  static const Icon password = Icon(Icons.password, size: 20);
  static const Icon emailOutlined = Icon(Icons.email_outlined, size: 20);
  static const Icon personOutlined = Icon(Icons.person_outlined, size: 20);

  // Icono de menú desplegable
  static const Icon moreHoriz = Icon(Icons.more_horiz, size: 20);
  // Iconos de configuración de depósitos.
  static const Icon dataThresholdingOutlined = Icon(
    Icons.data_thresholding_outlined,
    size: 20,
  );
  static const Icon groups2Outlined = Icon(Icons.groups_2_outlined, size: 20);
  static const Icon edit = Icon(Icons.edit, size: 20);
  static const Icon deleteOutline = Icon(
    Icons.delete_outline,
    color: AppColor.error,
    size: 20,
  );

  // Iconos de los gráficos al generar reportes.
  static const Icon analyticsOutlined = Icon(
    Icons.analytics_outlined,
    size: 20,
  );
  static const Icon pieChartOutline = Icon(Icons.pie_chart_outline, size: 20);
  static const Icon speed = Icon(Icons.speed, size: 20);
  static const Icon notificationsActiveOutlined = Icon(
    Icons.notifications_active_outlined,
    size: 20,
  );
  static const Icon tableChartOutlined = Icon(
    Icons.table_chart_outlined,
    size: 20,
  );

  // Iconos de parámetros
  static const Icon waterDrop = Icon(
    Icons.water_drop,
    color: AppColor.parameterAqua,
    size: 20,
  );
  static const Icon water = Icon(
    Icons.water,
    color: AppColor.parameterTurbidity,
    size: 20,
  );
  static const Icon scienceRounded = Icon(
    Icons.science_rounded,
    color: AppColor.parameterPH,
    size: 20,
  );

  // Iconos de calendario
  static const Icon calendarMonth = Icon(Icons.calendar_month, size: 20);

  // Íconos de la sección perfil.
  static const Icon lockOutline = Icon(Icons.lock_outline, size: 20);
  static const Icon colorLensOutlined = Icon(
    Icons.color_lens_outlined,
    size: 20,
  );
  static const Icon logoutOutlined = Icon(
    Icons.logout_outlined,
    color: AppColor.error,
    size: 20,
  );
  // Sección de alertas.
  static Icon deleteSweep({Color? color}) =>
      Icon(Icons.delete_sweep, size: 20, color: color ?? AppColor.error);
  static Icon notificationsOffOutlined({Color? color}) =>
      Icon(Icons.notifications_off_outlined, size: 50, color: color);

  // Iconos de en la sección agregar depósito
  static const Icon wifi = Icon(Icons.wifi, size: 20);
  static const Icon waterDamageOutlined = Icon(
    Icons.water_damage_outlined,
    size: 20,
  );

  // Iconos de en la sección generar reporte.
  static const Icon addChart = Icon(Icons.add_chart);
  static const Icon pdf = Icon(Icons.picture_as_pdf, color: AppColor.error);

  // Icono de contenedores interactivos.
  static const Icon arrowRight = Icon(
    Icons.arrow_forward_ios_rounded,
    size: 20,
  );

  // Icono de check.
  static const Icon check = Icon(Icons.check, size: 20, color: AppColor.white);

  // Iconos de en la sección perfil.
  static const Icon lightMode = Icon(Icons.light_mode, size: 20);
  static const Icon darkMode = Icon(Icons.dark_mode, size: 20);
}
