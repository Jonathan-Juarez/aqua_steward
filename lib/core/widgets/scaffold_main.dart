import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_safe.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

//Scaffold para la página principal.
class ScaffoldMain extends StatefulWidget {
  final List<Widget> children;
  final String? titleAppBar;
  //Llave global para el formulario.
  final GlobalKey<FormState>? formKey;
  final List<Widget>? actions;
  final Widget? body;
  final Widget? bottomNavigationBar;

  const ScaffoldMain({
    super.key,
    this.children = const [],
    this.titleAppBar,
    this.formKey,
    this.actions,
    this.body,
    this.bottomNavigationBar,
  });

  @override
  State<ScaffoldMain> createState() => _ScaffoldMainState();
}

class _ScaffoldMainState extends State<ScaffoldMain> {
  @override
  Widget build(BuildContext context) {
    // Se usa body si es proporcionado. De lo contrario, se construye el contenido a partir de children.
    final Widget content;
    if (widget.body != null) {
      content = widget.body!;
    } else {
      content = AppSafe(
        child: FadeInDown(
          duration: const Duration(milliseconds: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [...widget.children, AppSizedBox.height12],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: widget.titleAppBar != null
          ? AppBar(title: Text(widget.titleAppBar!), actions: widget.actions)
          : null,
      body: widget.formKey != null
          ? Form(key: widget.formKey, child: content)
          : content,

      //Botón flotante para agregar depósitos.
      floatingActionButton: widget.titleAppBar == null
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRouter.depositScreen),

              shape: const CircleBorder(),

              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: widget.titleAppBar == null
          ? FloatingActionButtonLocation.centerDocked
          : null,
      // Extiende el cuerpo para que el contenido se muestre detrás de la barra de navegación.
      extendBody: true,

      //Barra de navegación inferior para navegar entre páginas.
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
