import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

// El tamaño predeterminado de los iconos es 24px.
class AppIcon {
  // Iconos de botones de la pantalla de inicio.
  static Widget notificationsOutlined({BuildContext? context}) => HugeIcon(
    icon: HugeIcons.strokeRoundedNotification01,
    color: Theme.of(context!).colorScheme.onSurface,
  );

  static const Widget supportOutline = HugeIcon(
    icon: HugeIcons.strokeRoundedHelpCircle,
  );

  static const Widget contact = HugeIcon(
    icon: HugeIcons.strokeRoundedCustomerSupport,
  );

  static const Widget manual = HugeIcon(icon: HugeIcons.strokeRoundedBook01);
  static const Widget infoOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedInfo,
  );
  static const Widget privacyPolicy = HugeIcon(
    icon: HugeIcons.strokeRoundedShield01,
  );
  static const Widget code = HugeIcon(icon: HugeIcons.strokeRoundedCode);
  static const Widget launch = HugeIcon(
    icon: HugeIcons.strokeRoundedExternalLink,
    size: 20,
  );

  static Widget personAdd({Color? color}) =>
      HugeIcon(icon: HugeIcons.strokeRoundedUserAdd01, color: color);

  // Iconos de bottomNavigationBar.
  static const Widget homeOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedHome07,
    color: AppColor.whiteSecondary,
  );
  static const Widget home = HugeIcon(
    icon: HugeIcons.strokeRoundedHome07,
    color: AppColor.white,
  );
  static const Widget person = HugeIcon(
    icon: HugeIcons.strokeRoundedUser,
    color: AppColor.white,
  );
  static Widget personOutlined({Color? color, BuildContext? context}) =>
      HugeIcon(
        icon: HugeIcons.strokeRoundedUser,
        color: color ?? Theme.of(context!).colorScheme.onSurface,
      );

  // Iconos de auth
  static const Widget password = HugeIcon(
    icon: HugeIcons.strokeRoundedLockPassword,
  );
  static const Widget emailOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedMail01,
  );
  static const Widget visibility = HugeIcon(icon: HugeIcons.strokeRoundedEye);
  static const Widget visibilityOff = HugeIcon(
    icon: HugeIcons.strokeRoundedEyeClosed,
  );
  static const Widget add = HugeIcon(icon: HugeIcons.strokeRoundedAdd01);
  static Widget addCircleOutline({BuildContext? context}) => HugeIcon(
    icon: HugeIcons.strokeRoundedAddCircle,
    size: 16,
    color: Theme.of(context!).colorScheme.onSurface.withOpacity(0.5),
  );
  static const Widget checkCircle = HugeIcon(
    icon: HugeIcons.strokeRoundedCheckmarkCircle02,
    color: AppColor.success,
    size: 16,
  );
  static const Widget cancel = HugeIcon(
    icon: HugeIcons.strokeRoundedCancelCircle,
    color: AppColor.error,
    size: 16,
  );

  // Iconos de parámetros
  static const Widget waterDrop = HugeIcon(
    icon: HugeIcons.strokeRoundedDroplet,
    color: AppColor.parameterAqua,
  );
  static const Widget water = HugeIcon(
    icon: HugeIcons.strokeRoundedWaves,
    color: AppColor.parameterTurbidity,
  );
  static const Widget scienceRounded = HugeIcon(
    icon: HugeIcons.strokeRoundedFlaskConical,
    color: AppColor.parameterPH,
  );

  // Íconos de la sección perfil.
  static const Widget lockOutline = HugeIcon(
    icon: HugeIcons.strokeRoundedLockKey,
  );
  static const Widget logoutOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedLogout01,
  );
  static const Widget noAccounts = HugeIcon(
    icon: HugeIcons.strokeRoundedUserBlock01,
  );
  static const Widget languageOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedLanguages,
  );

  // Sección técnico
  static Widget personOff({BuildContext? context}) => HugeIcon(
    icon: HugeIcons.strokeRoundedUserBlock01,
    size: 50,
    color: Theme.of(context!).colorScheme.onSurfaceVariant,
  );

  // Sección de alertas.
  static Widget doneAll({Color? color}) =>
      HugeIcon(icon: HugeIcons.strokeRoundedTickDouble01, color: color);
  static const Icon deleteOutline = Icon(
    Icons.delete_outline,
    color: AppColor.error,
    size: 20,
  );
  static Icon deleteSweep({Color? color}) =>
      Icon(Icons.delete_sweep_outlined, color: color ?? AppColor.error);
  static Widget notificationsOffOutlined({BuildContext? context}) => HugeIcon(
    icon: HugeIcons.strokeRoundedNotificationOff01,
    size: 50,
    color: Theme.of(context!).colorScheme.onSurfaceVariant,
  );

  // Iconos de en la sección agregar depósito
  static const Widget wifi = HugeIcon(icon: HugeIcons.strokeRoundedWifi01);
  static Widget wifiOff({double? size}) =>
      HugeIcon(icon: HugeIcons.strokeRoundedWifiOff01, size: size ?? 20);
  static Widget wifiFind({double? size}) =>
      HugeIcon(icon: HugeIcons.strokeRoundedWifi01, size: size ?? 20);
  static const Widget sensors = HugeIcon(icon: HugeIcons.strokeRoundedCpu);
  static const Widget waterDamageOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedDroplet,
  );
  static const Widget localDrinkOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedPolyTank,
  );
  static const Widget heightOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedParagraphSpacing,
  );
  static const Widget straightenOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedRuler,
  );

  // Iconos de calendario
  static Widget calendarMonth({Color? color, BuildContext? context}) =>
      HugeIcon(
        icon: HugeIcons.strokeRoundedCalendar01,
        color: color ?? Theme.of(context!).colorScheme.onSurface,
      );

  // Iconos de los gráficos al generar reportes.
  static const Widget lineChart = HugeIcon(
    icon: HugeIcons.strokeRoundedAnalytics01,
  );
  static const Widget linearProgress = HugeIcon(
    icon: HugeIcons.strokeRoundedBarChart,
  );
  static const Widget speed = HugeIcon(
    icon: HugeIcons.strokeRoundedDashboardSpeed01,
  );

  static const Widget tableChartOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedGridTable,
  );

  // Iconos de en la sección de reporte.
  static const Widget addChart = HugeIcon(
    icon: HugeIcons.strokeRoundedAnalytics01,
  );
  static Widget pdf({BuildContext? context}) => HugeIcon(
    icon: HugeIcons.strokeRoundedPdf02,
    color: Theme.of(context!).colorScheme.onSurface,
  );
  static Widget csv({BuildContext? context}) => HugeIcon(
    icon: HugeIcons.strokeRoundedCsv02,
    color: Theme.of(context!).colorScheme.onSurface,
  );

  // Icono de contenedor list tile.
  static Widget arrowRight({Color? color}) => HugeIcon(
    icon: HugeIcons.strokeRoundedArrowRight01,
    color: color ?? AppColor.error,
  );

  // Icono de ubicación
  static const Widget locationOnOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedLocation03,
    size: 20,
  );

  // Icono de menú desplegable de depósitos.
  static const Widget moreHoriz = HugeIcon(
    icon: HugeIcons.strokeRoundedMoreHorizontal,
  );
  // Iconos de configuración de depósitos.
  static const Widget dataThresholdingOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedAnalytics02,
    size: 20,
  );
  static Widget groups2Outlined({BuildContext? context}) => HugeIcon(
    icon: HugeIcons.strokeRoundedUserGroup02,
    size: 20,
    color: Theme.of(context!).colorScheme.onSurface,
  );
  static Widget edit({Color? color, BuildContext? context, double? size}) =>
      HugeIcon(
        icon: HugeIcons.strokeRoundedEdit03,
        size: size ?? 20,
        color: color ?? Theme.of(context!).colorScheme.onSurface,
      );

  // Iconos de menú desplegable de tema.
  static const Widget colorLensOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedPaintBoard,
  );

  static const Widget systemMode = HugeIcon(
    icon: HugeIcons.strokeRoundedComputer,
  );
  static const Widget lightMode = HugeIcon(icon: HugeIcons.strokeRoundedSun01);
  static const Widget darkMode = HugeIcon(icon: HugeIcons.strokeRoundedMoon);

  // Íconos del pdf.
  static const Widget print = HugeIcon(icon: HugeIcons.strokeRoundedPrinter);
  static const Widget share = HugeIcon(icon: HugeIcons.strokeRoundedShare01);
}
