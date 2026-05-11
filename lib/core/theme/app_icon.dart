import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppIcon {
  // Iconos de botones dela pantalla de inicio.
  static Icon notificationsOutlined({Color? color}) =>
      Icon(Icons.notifications_outlined, size: 24, color: color);
  static Icon supportOutline({Color? color}) =>
      Icon(Icons.help_outline, size: 24, color: color);

  static const Icon contact = Icon(Icons.contact_support, size: 24);

  static const Icon manual = Icon(Icons.menu_book_rounded, size: 24);
  static const Icon infoOutlined = Icon(Icons.info_outlined, size: 24);
  static const Icon code = Icon(Icons.code, size: 24);

  static Icon personAdd({Color? color}) =>
      Icon(Icons.person_add_alt_1_outlined, size: 24, color: color);

  // Iconos de bottomNavigationBar.
  static const Icon homeOutlined = Icon(
    Icons.home_outlined,
    color: AppColor.white,
    size: 24,
  );
  static const Icon home = Icon(Icons.home, color: AppColor.white, size: 24);
  static const Icon person = Icon(
    Icons.person,
    color: AppColor.white,
    size: 24,
  );
  static Icon personOutlined({Color? color, BuildContext? context}) => Icon(
    Icons.person_outlined,
    color: color ?? Theme.of(context!).colorScheme.onSurface,
    size: 24,
  );

  // Iconos de auth
  static const Icon password = Icon(Icons.password, size: 24);
  static const Icon emailOutlined = Icon(Icons.email_outlined, size: 24);

  // Iconos de parámetros
  static const Icon waterDrop = Icon(
    Icons.water_drop,
    color: AppColor.parameterAqua,
    size: 24,
  );
  static const Icon water = Icon(
    Icons.water,
    color: AppColor.parameterTurbidity,
    size: 24,
  );
  static const Icon scienceRounded = Icon(
    Icons.science_rounded,
    color: AppColor.parameterPH,
    size: 24,
  );

  // Íconos de la sección perfil.
  static const Icon lockOutline = Icon(Icons.lock_outline, size: 24);
  static const Icon logoutOutlined = Icon(
    Icons.logout_outlined,
    color: AppColor.error,
    size: 24,
  );
  static const Icon languageOutlined = Icon(Icons.language_outlined, size: 24);
  // Sección de alertas.
  static Icon deleteSweep({Color? color}) =>
      Icon(Icons.delete_sweep, size: 24, color: color ?? AppColor.error);
  static Icon notificationsOffOutlined({Color? color}) =>
      Icon(Icons.notifications_off_outlined, size: 50, color: color);

  // Iconos de en la sección agregar depósito
  static const Icon wifi = Icon(Icons.wifi, size: 24);
  static const Icon waterDamageOutlined = Icon(
    Icons.water_damage_outlined,
    size: 24,
  );
  static const Icon qrCodeScanner = Icon(Icons.qr_code_scanner, size: 20);

  // Iconos de calendario
  static Icon calendarMonth({Color? color, BuildContext? context}) => Icon(
    Icons.calendar_month,
    size: 24,
    color: color ?? Theme.of(context!).colorScheme.onSurface,
  );

  // Iconos de los gráficos al generar reportes.
  static const Icon lineChart = Icon(Icons.line_axis_rounded, size: 24);
  static const Icon pieChartOutline = Icon(Icons.pie_chart_outline, size: 24);
  static const Icon speed = Icon(Icons.speed, size: 24);
  static const Icon notificationsActiveOutlined = Icon(
    Icons.notifications_active_outlined,
    size: 24,
  );
  static const Icon tableChartOutlined = Icon(
    Icons.table_chart_outlined,
    size: 24,
  );

  // Iconos de en la sección de reporte.
  static const Icon addChart = Icon(Icons.add_chart, size: 24);
  static const Icon pdf = Icon(
    Icons.picture_as_pdf,
    size: 24,
    color: AppColor.error,
  );
  static const Icon download = Icon(Icons.file_download_outlined, size: 24);

  // Icono de contenedor list tile.
  static Icon arrowRight({Color? color}) => Icon(
    Icons.keyboard_arrow_right_outlined,
    size: 24,
    color: color ?? AppColor.error,
  );

  // Icono de menú desplegable de depósitos.
  static const Icon moreHoriz = Icon(Icons.more_horiz, size: 24);
  // Iconos de configuración de depósitos.
  static const Icon dataThresholdingOutlined = Icon(
    Icons.data_thresholding_outlined,
    size: 20,
  );
  static const Icon groups2Outlined = Icon(Icons.groups_2_outlined, size: 20);
  static Icon edit({Color? color, BuildContext? context}) => Icon(
    Icons.edit,
    size: 20,
    color: color ?? Theme.of(context!).colorScheme.onSurface,
  );
  static const Icon deleteOutline = Icon(
    Icons.delete_outline,
    color: AppColor.error,
    size: 20,
  );

  // Iconos de menú desplegable de tema.
  static const Icon colorLensOutlined = Icon(
    Icons.color_lens_outlined,
    size: 20,
  );
  static const Icon lightMode = Icon(Icons.light_mode, size: 20);
  static const Icon darkMode = Icon(Icons.dark_mode, size: 20);

  // Íconos del pdf.
  static const Icon print = Icon(Icons.print, size: 24);
  static const Icon share = Icon(Icons.share, size: 24);

  // Íconos de estado.
  static const Icon warning = Icon(
    Icons.warning_rounded,
    size: 20,
    color: AppColor.warning,
  );
  static const Icon success = Icon(
    Icons.check_circle,
    size: 20,
    color: AppColor.success,
  );
}
