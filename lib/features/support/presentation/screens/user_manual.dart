import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:flutter/material.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldMain(
      titleAppBar: "Manual de usuario",
      children: [Center(child: Text('Manual de usuario'))],
    );
  }
}
