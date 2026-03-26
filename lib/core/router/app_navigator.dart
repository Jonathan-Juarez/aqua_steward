import 'package:flutter/material.dart';

// Clase para aplicar la animación globalmente a las rutas con pushNamed o pushReplacementNamed.
class AppNavigator extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Retorna una transición de desvanecimiento.
    return FadeTransition(opacity: animation, child: child);
  }
}
