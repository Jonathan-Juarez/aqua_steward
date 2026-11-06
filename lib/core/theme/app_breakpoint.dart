import 'package:flutter/material.dart';

class AppBreakpoint {
  // Móviles vertical.
  static const double mobileSmall = 320;
  // Tablet o celular horizontal.
  static const double tablet = 700;
  // Escritorio y web amplia.
  static const double desktop = 960;
  // Ancho máximo recomendado de contenido en pantallas grandes.
  static const double contentMaxWidth = 700;
  // Ancho máximo para vista de escritorio.
  static const double desktopMaxWidth = 960;

  // Obtiene el ancho actual de la pantalla.
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  // Obtiene la altura actual de la pantalla.
  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  // Determina si la pantalla es móvil compacto.
  static bool isSmallMobile(BuildContext context) =>
      width(context) <= mobileSmall;

  // Determina si la pantalla es móvil estándar.
  static bool isMobile(BuildContext context) => width(context) < tablet;

  // Determina si la pantalla corresponde a tablet exclusivamente.
  static bool isTabletOnly(BuildContext context) =>
      width(context) >= tablet && width(context) < desktop;

  // Determina si la pantalla es tablet o más grande.
  static bool isTablet(BuildContext context) => width(context) >= tablet;

  // Determina si la pantalla es de escritorio.
  static bool isDesktop(BuildContext context) => width(context) >= desktop;
}
