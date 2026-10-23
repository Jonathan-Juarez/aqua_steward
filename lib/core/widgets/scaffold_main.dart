import 'package:aqua_steward/core/theme/app_breakpoint.dart';
import 'package:aqua_steward/core/theme/app_safe.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/responsive_grid.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/logo.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

// Scaffold para toda la aplicación con soporte responsivo y de cuenta.
class ScaffoldMain extends StatelessWidget {
  final List<Widget> children;
  final Widget? body;
  final Widget? header;
  final Widget? footer;
  final String? titleAppBar;
  // Llave global para el formulario.
  final GlobalKey<FormState>? formKey;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Future<void> Function()? onRefresh;
  final bool isScrollable;
  // Activa la cuadrícula responsiva (ResponsiveGrid) y expande el ancho a desktopMaxWidth.
  final bool isResponsive;
  final bool showLogo;
  final bool centerContent;
  final double? maxWidth;
  final bool isLoading;
  final Widget? skeletonItem;
  final int? skeletonCount;

  // Constructor estándar para pantallas de la aplicación.
  const ScaffoldMain({
    super.key,
    this.children = const [],
    this.body,
    this.header,
    this.footer,
    this.titleAppBar,
    this.formKey,
    this.actions,
    this.bottomNavigationBar,
    this.onRefresh,
    this.isScrollable = true,
    this.isResponsive = false,
    this.showLogo = false,
    this.centerContent = false,
    this.maxWidth,
    this.isLoading = false,
    this.skeletonItem,
    this.skeletonCount,
  });

  // Constructor especializado para pantallas de autenticación y cuenta.
  const ScaffoldMain.account({
    Key? key,
    required Widget body,
    GlobalKey<FormState>? formKey,
    double maxWidth = AppBreakpoint.contentMaxWidth,
  }) : this(
         key: key,
         body: body,
         formKey: formKey,
         showLogo: true,
         centerContent: true,
         isResponsive: false,
         maxWidth: maxWidth,
       );

  @override
  Widget build(BuildContext context) {
    // Ancho máximo: expande a desktopMaxWidth (960px) en escritorio o si es responsivo, o restringe a contentMaxWidth (700px).
    final double effectiveMaxWidth =
        maxWidth ??
        (AppBreakpoint.isDesktop(context) || isResponsive
            ? AppBreakpoint.desktopMaxWidth
            : AppBreakpoint.contentMaxWidth);

    // Contenido principal: si es responsivo y tiene children, activa ResponsiveGrid automáticamente.
    final Widget mainContent;
    if (body != null) {
      mainContent = body!;
    } else if (isResponsive && children.isNotEmpty) {
      mainContent = ResponsiveGrid(
        items: children,
        isLoading: isLoading,
        skeletonItem: skeletonItem,
        skeletonCount: skeletonCount,
      );
    } else {
      mainContent = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }

    final List<Widget> columnElements = [
      if (showLogo) const Center(child: Logo()),
      if (header != null) header!,
      mainContent,
      if (footer != null) ...[AppSizedBox.height12, footer!],
      if (!centerContent) AppSizedBox.height12,
    ];

    final Widget columnContent = Column(
      mainAxisAlignment: centerContent
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnElements,
    );

    final Widget animatedChild = showLogo
        ? FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: columnContent,
          )
        : FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: columnContent,
          );

    final Widget content;
    if (isScrollable) {
      content = AppSafe(onRefresh: onRefresh, child: animatedChild);
    } else {
      // Contenido directo sin scroll vertical (usado en PageView y PdfPreview).
      content = AppSafe(
        isScrollable: false,
        child:
            body ??
            (children.isNotEmpty ? children.first : const SizedBox.shrink()),
      );
    }

    final Widget constrainedBody = Align(
      alignment: centerContent ? Alignment.center : Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: content,
      ),
    );

    return Scaffold(
      appBar: titleAppBar != null
          ? AppBar(title: Text(titleAppBar!), actions: actions)
          : null,
      body: formKey != null
          ? Form(key: formKey, child: constrainedBody)
          : constrainedBody,
      extendBody: true,
      // Barra de navegación inferior para navegar entre páginas.
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
