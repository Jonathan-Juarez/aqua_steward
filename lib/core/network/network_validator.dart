import 'dart:async';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  StreamSubscription? _connectivitySub;
  bool? _hasInternet;

  @override
  void initState() {
    super.initState();
    _initNetworkListener();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  Future<void> _initNetworkListener() async {
    // Verificación inicial de conectividad real.
    final isConnected = await InternetConnection().hasInternetAccess;
    if (!mounted) return;
    _hasInternet = isConnected;
    if (!isConnected) _snackbarNoConnection();

    // Escucha cambios de interfaz de red (WiFi/datos encendidos o apagados).
    _connectivitySub = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      if (!mounted) return;

      // Determina si al menos una interfaz de red está activa.
      final hasInterface = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (!hasInterface) {
        // Si WiFi/datos están apagados, se notifica sin conexión.
        if (_hasInternet != false) {
          _hasInternet = false;
          _snackbarNoConnection();
        }
      } else if (_hasInternet == false) {
        // La interfaz de red se reactivó, confirma acceso real a internet.
        final hasAccess = await InternetConnection().hasInternetAccess;
        if (!mounted) return;

        if (hasAccess) {
          _hasInternet = true;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          // Muestra el mensaje de conexión restaurada.
          SnackBarFormat(
            context: context,
            message: context.l10n.red_conexion_restaurada,
          ).show();
          // Refresca los depósitos automáticamente al restaurar la conexión.
          _refreshDeposits();
        }
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
