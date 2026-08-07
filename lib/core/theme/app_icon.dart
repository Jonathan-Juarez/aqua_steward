import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:flutter/material.dart';

// El tamaño predeterminado de los iconos es 24px.
class AppIcon {
  // Iconos de botones de la pantalla de inicio.
  static Icon notificationsOutlined({BuildContext? context}) => Icon(
    Icons.notifications_outlined,
    color: Theme.of(context!).colorScheme.onSurface,
  );

  static const Icon supportOutline = Icon(Icons.help_outline);

  static const Icon contact = Icon(Icons.contact_support);

  static const Icon manual = Icon(Icons.menu_book_rounded);
  static const Icon infoOutlined = Icon(Icons.info_outlined);
  static const Icon privacyPolicy = Icon(Icons.privacy_tip_outlined);
  static const Icon code = Icon(Icons.code);
  static const Icon launch = Icon(Icons.launch, size: 20);

  static Icon personAdd({Color? color}) =>
      Icon(Icons.person_add_alt_1_outlined, color: color);

  // Iconos de bottomNavigationBar.
  static const Icon homeOutlined = Icon(
    Icons.home_outlined,
    color: AppColor.white,
  );
  static const Icon home = Icon(Icons.home, color: AppColor.white);
  static const Icon person = Icon(Icons.person, color: AppColor.white);
  static Icon personOutlined({Color? color, BuildContext? context}) => Icon(
    Icons.person_outlined,
    color: color ?? Theme.of(context!).colorScheme.onSurface,
  );

  // Iconos de auth
  static const Icon password = Icon(Icons.password);
  static const Icon emailOutlined = Icon(Icons.email_outlined);
  static Icon addCircleOutline({BuildContext? context}) => Icon(
    Icons.add_circle_outline_rounded,
    size: 16,
    color: Theme.of(context!).colorScheme.onSurface.withOpacity(0.5),
  );
  static const Icon checkCircle = Icon(
    Icons.check_circle,
    color: AppColor.success,
    size: 16,
  );
  static const Icon cancel = Icon(
    Icons.cancel,
    color: AppColor.error,
    size: 16,
  );

  // Iconos de parámetros
  static const Icon waterDrop = Icon(
    Icons.water_drop,
    color: AppColor.parameterAqua,
  );
  static const Icon water = Icon(
    Icons.water,
    color: AppColor.parameterTurbidity,
  );
  static const Icon scienceRounded = Icon(
    Icons.science_rounded,
    color: AppColor.parameterPH,
  );

  // Íconos de la sección perfil.
  static const Icon lockOutline = Icon(Icons.lock_outline);
  static const Icon logoutOutlined = Icon(Icons.logout_outlined);
  static const Icon noAccounts = Icon(Icons.no_accounts);
  static const Icon languageOutlined = Icon(Icons.language_outlined);
  static const Icon dashboard = Icon(Icons.dashboard);

  // Sección técnico
  static Icon personOff({BuildContext? context}) => Icon(
    Icons.person_off,
    size: 50,
    color: Theme.of(context!).colorScheme.onSurfaceVariant,
  );

  // Sección de alertas.
  static Icon doneAll({Color? color}) => Icon(Icons.done_all, color: color);
  static Icon deleteSweep({Color? color}) =>
      Icon(Icons.delete_sweep, color: color ?? AppColor.error);
  static Icon notificationsOffOutlined({BuildContext? context}) => Icon(
    Icons.notifications_off_outlined,
    size: 50,
    color: Theme.of(context!).colorScheme.onSurfaceVariant,
  );

  // Iconos de en la sección agregar depósito
  static const Icon wifi = Icon(Icons.wifi);
  static const Icon waterDamageOutlined = Icon(Icons.water_damage_outlined);
  static const Icon qrCodeScanner = Icon(Icons.qr_code_scanner);
  static const Icon localDrinkOutlined = Icon(Icons.local_drink_outlined);
  static const Icon heightOutlined = Icon(Icons.height_outlined);
  static const Icon straightenOutlined = Icon(Icons.straighten_outlined);

  // Iconos de calendario
  static Icon calendarMonth({Color? color, BuildContext? context}) => Icon(
    Icons.calendar_month,
    color: color ?? Theme.of(context!).colorScheme.onSurface,
  );

  // Iconos de los gráficos al generar reportes.
  static const Icon lineChart = Icon(Icons.line_axis_rounded);
  static const Icon pieChartOutline = Icon(Icons.pie_chart_outline);
  static const Icon speed = Icon(Icons.speed);

  static const Icon tableChartOutlined = Icon(Icons.table_chart_outlined);

  // Iconos de en la sección de reporte.
  static const Icon addChart = Icon(Icons.add_chart);
  static const Icon pdf = Icon(Icons.picture_as_pdf);
  static const Icon download = Icon(Icons.file_download_outlined);

  // Icono de contenedor list tile.
  static Icon arrowRight({Color? color}) =>
      Icon(Icons.keyboard_arrow_right_outlined, color: color ?? AppColor.error);

  // Icono de menú desplegable de depósitos.
  static const Icon moreHoriz = Icon(Icons.more_horiz);
  // Iconos de configuración de depósitos.
  static const Icon dataThresholdingOutlined = Icon(
    Icons.data_thresholding_outlined,
    size: 20,
  );
  static const Icon groups2Outlined = Icon(Icons.groups_2_outlined, size: 20);
  static Icon edit({Color? color, BuildContext? context, double? size}) => Icon(
    Icons.edit,
    size: size ?? 20,
    color: color ?? Theme.of(context!).colorScheme.onSurface,
  );
  static const Icon deleteOutline = Icon(
    Icons.delete_outline,
    color: AppColor.error,
    size: 20,
  );

  // Iconos de menú desplegable de tema.
  static const Icon colorLensOutlined = Icon(Icons.color_lens_outlined);
  static const Icon systemMode = Icon(Icons.settings_display);
  static const Icon lightMode = Icon(Icons.light_mode);
  static const Icon darkMode = Icon(Icons.dark_mode);

  // Íconos del pdf.
  static const Icon print = Icon(Icons.print);
  static const Icon share = Icon(Icons.share);
}
