import 'dart:async';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

class NetworkValidator extends StatefulWidget {
  final Widget screen;
  const NetworkValidator({super.key, required this.screen});

  @override
  State<NetworkValidator> createState() => _NetworkValidatorState();
}

class _NetworkValidatorState extends State<NetworkValidator> {
  StreamSubscription? _connectionSub;
  bool? _hasInternet;

  @override
  void initState() {
    super.initState();
    _initNetworkListener();
  }

  @override
  void dispose() {
    _connectionSub?.cancel();
    super.dispose();
  }

  Future<void> _initNetworkListener() async {
    // Si inicia sin internet, muestra snackbar.
    final isConnected = await InternetConnection().hasInternetAccess;
    if (!mounted) return;
    _hasInternet = isConnected;
    if (!isConnected) _snackbarNoConnection();

    // Escucha cambios futuros de estado de red.
    _connectionSub = InternetConnection().onStatusChange.listen((status) {
      if (!mounted) return;
      final connected = status == InternetStatus.connected;

      // Solo reacciona si el estado realmente cambió.
      if (_hasInternet == connected) return;
      _hasInternet = connected;

      if (connected) {
        // Oculta el aviso persistente de sin conexión.
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Muestra el mensaje de conexión restaurada.
        SnackBarFormat(
          context: context,
          message: context.l10n.red_conexion_restaurada,
        ).show();
        // Refresca los depósitos automáticamente al restaurar la conexión.
        _refreshDeposits();
      } else {
        _snackbarNoConnection();
      }
    });
  }

  void _snackbarNoConnection() => SnackBarFormat(
    context: context,
    message: context.l10n.red_sin_conexion,
    duration: 365,
    isError: true,
  ).show();

  // Refresca los depósitos usando el token actual del AuthProvider.
  void _refreshDeposits() {
    final token = context.read<AuthProvider>().currentUser?.token ?? '';
    if (token.isNotEmpty) {
      context.read<DepositProvider>().getDeposits(token: token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.screen;
  }
}
