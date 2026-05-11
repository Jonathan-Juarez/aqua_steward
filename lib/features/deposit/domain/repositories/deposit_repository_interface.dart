import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';
import 'package:aqua_steward/features/deposit/data/models/deposit_model.dart';

abstract class IDepositRepository {
  // Contrato para obtener la lista de depósitos del servidor.
  Future<Result<List<Deposit>>> getDeposits({required String token});

  // Contrato para crear un nuevo depósito en el sistema.
  Future<Result<void>> createDeposit({
    required DepositModel deposit,
    required String token,
  });

  // Contrato para eliminar un depósito existente mediante su ID.
  Future<Result<void>> deleteDeposit({
    required String depositId,
    required String token,
  });

  Future<Result<void>> updateDeposit({
    required String depositId,
    required String token,
    required DepositModel deposit,
  });
}
