import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_safe.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/bottom_bar_format.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

//Scaffold para la página principal.
class ScaffoldMain extends StatefulWidget {
  final List<Widget> children;
  final String? titleAppBar;
  final int selectedIndex;
  //Llave global para el formulario.
  final GlobalKey<FormState>? formKey;
  const ScaffoldMain({
    super.key,
    required this.children,
    this.titleAppBar,
    this.selectedIndex = 0,
    this.formKey,
  });

  @override
  State<ScaffoldMain> createState() => _ScaffoldMainState();
}

class _ScaffoldMainState extends State<ScaffoldMain> {
  @override
  Widget build(BuildContext context) {
    final content = AppSafe(
      child: FadeInDown(
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [...widget.children, AppSizedBox.height16],
        ),
      ),
    );
    return Scaffold(
      appBar: widget.titleAppBar != null
          ? AppBar(title: Text(widget.titleAppBar!))
          : null,
      body: widget.formKey != null
          ? Form(key: widget.formKey, child: content)
          : content,

      //Botón flotante para agregar depósitos.
      floatingActionButton: widget.titleAppBar == null
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRouter.addDeposit),

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
      bottomNavigationBar: widget.titleAppBar == null
          ? BottomBarFormat(selectedIndex: widget.selectedIndex)
          : null,
    );
  }
}
