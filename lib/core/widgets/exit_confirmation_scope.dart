import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitConfirmationScope extends StatefulWidget {
  final Widget child;

  const ExitConfirmationScope({super.key, required this.child});

  @override
  State<ExitConfirmationScope> createState() => _ExitConfirmationScopeState();
}

class _ExitConfirmationScopeState extends State<ExitConfirmationScope> {
  static const _channel = MethodChannel('aqua_steward/app');
  DateTime? _lastPressedAt;

  Future<void> _moveToBackground() async {
    try {
      await _channel.invokeMethod('moveToBackground');
    } catch (_) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          SnackBarFormat.show(
            context,
            context.l10n.dialogo_presiona_nuevamente_salir,
          );
        } else {
          _moveToBackground();
        }
      },
      child: widget.child,
    );
  }
}
