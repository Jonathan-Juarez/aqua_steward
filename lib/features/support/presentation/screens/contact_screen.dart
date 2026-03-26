import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldMain(
      titleAppBar: "Contacto",
      children: [Center(child: Text('Contacto'))],
    );
  }
}
