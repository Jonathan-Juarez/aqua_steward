import 'package:animate_do/animate_do.dart';
import 'package:aqua_steward/core/theme/app_safe.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';

// Widget Scaffold para el ingreso de cuenta.
class ScaffoldAccount extends StatefulWidget {
  final Widget body;
  final GlobalKey<FormState>? formKey;
  const ScaffoldAccount({super.key, required this.body, this.formKey});

  @override
  State<ScaffoldAccount> createState() => _ScaffoldAccountState();
}

class _ScaffoldAccountState extends State<ScaffoldAccount> {
  @override
  Widget build(BuildContext context) {
    final content = AppSafe(
      child: FadeInLeft(
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Logo(), widget.body],
        ),
      ),
    );
    return Scaffold(
      body: widget.formKey != null
          ? Form(key: widget.formKey, child: content)
          : content,
    );
  }
}
