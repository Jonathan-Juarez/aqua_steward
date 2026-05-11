import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/deposit/data/models/deposit_model.dart';
import 'package:aqua_steward/features/deposit/domain/repositories/deposit_repository_interface.dart';

class CreateDepositUseCase {
  final IDepositRepository repository;

  CreateDepositUseCase(this.repository);

  // Ejecuta la acción de crear un nuevo depósito en el servidor central.
  Future<Result<void>> call({
    required DepositModel deposit,
    required String token,
  }) {
    // Delega la creación del depósito específico al repositorio inyectado.
    return repository.createDeposit(deposit: deposit, token: token);
  }
}
