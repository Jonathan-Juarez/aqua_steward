import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:flutter/material.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldMain(
      titleAppBar: "Miembros",
      children: [Center(child: Text('Miembros'))],
    );
  }
}
