import 'dart:async';
import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/deposit/data/models/deposit_model.dart';
import 'package:aqua_steward/features/deposit/domain/usecases/create_deposit_usecase.dart';
import 'package:aqua_steward/features/deposit/domain/usecases/delete_deposit_usecase.dart';
import 'package:aqua_steward/features/deposit/domain/usecases/get_deposits_usecase.dart';
import 'package:aqua_steward/features/deposit/domain/usecases/update_deposit_usecase.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';
import 'package:aqua_steward/core/network/socket_service.dart';
import 'package:flutter/material.dart';

class DepositProvider extends ChangeNotifier {
  final GetDepositsUseCase getDepositsUseCase;
  final CreateDepositUseCase createDepositUseCase;
  final DeleteDepositUseCase deleteDepositUseCase;
  final UpdateDepositUsecase updateDepositUseCase;

  DepositProvider({
    required this.getDepositsUseCase,
    required this.createDepositUseCase,
    required this.deleteDepositUseCase,
    required this.updateDepositUseCase,
  }) {
    _initSocket();
  }

  final SocketService _socketService = SocketService();
  final Map<String, Map<String, double>> _realTimeData = {};
  Timer? _socketTimer;
  bool _needsNotify = false;

  // Se asignan valores en tiempo real a los depósitos suscritos.
  Map<String, Map<String, double>> get realTimeData => _realTimeData;

  void _initSocket() async {
    // Se inicia el temporizador para notificar a los escuchadores para evitar el parpadeo de la UI.
    _socketTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_needsNotify) {
        _needsNotify = false;
        notifyListeners();
      }
    });

    await _socketService.connect((ip, type, value) {
      if (!_realTimeData.containsKey(ip)) {
        _realTimeData[ip] = {'level': 0.0, 'ph': 0.0, 'turbidity': 0.0};
      }
      _realTimeData[ip]![type] = value;
      _needsNotify = true;
    });
  }

  void _subscribeToDeposits() {
    for (var deposit in _deposits) {
      if (deposit.ip != null && deposit.ip!.isNotEmpty) {
        _socketService.subscribeTo(deposit.ip!);
      }
    }
  }

  List<Deposit> _deposits = [];
  List<Deposit> get deposits => _deposits;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _socketTimer?.cancel();
    _socketService.disconnect();
    super.dispose();
  }

  // Limpia la lista de depósitos y los datos en tiempo real al cerrar sesión.
  void clearDeposits() {
    _deposits = [];
    _realTimeData.clear();
    notifyListeners();
  }

  // Carga la lista de depósitos desde el dominio y notifica a la vista.
  Future<Result<List<Deposit>>> getDeposits({required String token}) async {
    // Activa el estado de carga para feedback visual en la interfaz.
    _isLoading = true;
    notifyListeners();

    try {
      // Solicita la colección de depósitos al caso de uso correspondiente.
      final result = await getDepositsUseCase.call(token: token);
      if (result.isSuccess) {
        // El backend ya filtra por owner_id usando el token JWT.
        _deposits = result.data!;
        _subscribeToDeposits();
      }
      // Retorna el objeto Result para ser manejado directamente por la vista.
      return result;
    } catch (e) {
      // Captura y retorna errores inesperados durante el flujo de carga.
      return Result.failure(e.toString());
    } finally {
      // Desactiva el indicador de carga y redibuja los escuchadores (Consumer).
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ejecuta la creación de un nuevo depósito y sincroniza la lista local.
  Future<Result<void>> createDeposit({
    required DepositModel deposit,
    required String token,
  }) async {
    // Inicia el spinner de carga para la acción de guardado.
    _isLoading = true;
    notifyListeners();

    try {
      // Invoca el caso de uso de creación con los datos del modelo.
      final result = await createDepositUseCase.call(
        deposit: deposit,
        token: token,
      );
      if (result.isSuccess) {
        // Refresca la lista de depósitos para reflejar el nuevo registro.
        await getDeposits(token: token);
      }
      return result;
    } catch (e) {
      // Retorna excepciones técnicas como fallos en el Result.
      return Result.failure(e.toString());
    } finally {
      // Libera el estado de carga al finalizar la operación.
      _isLoading = false;
      notifyListeners();
    }
  }

  // Procesa la eliminación de un depósito por ID y actualiza el estado.
  Future<Result<void>> deleteDeposit({
    required String depositId,
    required String token,
  }) async {
    // Activa el indicador de carga para la operación de borrado.
    _isLoading = true;
    notifyListeners();

    try {
      // Delega la eliminación al caso de uso de dominio especializado.
      final result = await deleteDepositUseCase.call(
        depositId: depositId,
        token: token,
      );
      if (result.isSuccess) {
        // Elimina el depósito de la lista local inmediatamente para fluidez visual.
        _deposits.removeWhere((deposit) => deposit.id == depositId);
      }
      return result;
    } catch (e) {
      // Gestiona fallos inesperados de red o persistencia.
      return Result.failure(e.toString());
    } finally {
      // Notifica el fin de la carga a los componentes suscritos.
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualiza un depósito existente y sincroniza la lista local.
  Future<Result<void>> updateDeposit({
    required String depositId,
    required DepositModel deposit,
    required String token,
  }) async {
    // Activa el indicador de carga para la operación de actualización.
    _isLoading = true;
    notifyListeners();

    try {
      // Delega la actualización al caso de uso de dominio especializado.
      final result = await updateDepositUseCase.updateDeposit(
        depositId: depositId,
        token: token,
        deposit: deposit,
      );
      if (result.isSuccess) {
        // Reflejo visual inmediato para evitar visualización atascada de variables modificadas.
        final index = _deposits.indexWhere(
          (deposit) => deposit.id == depositId,
        );
        // Se valida que el depósito exista en la lista para actualizarlo.
        if (index != -1) {
          _deposits[index] = deposit;
        }
        // Llamada en segundo plano para corroborar la db.
        getDeposits(token: token);
      }
      return result;
    } catch (e) {
      // Gestiona fallos inesperados de red o persistencia.
      return Result.failure(e.toString());
    } finally {
      // Notifica el fin de la carga a los componentes suscritos.
      _isLoading = false;
      notifyListeners();
    }
  }
}
