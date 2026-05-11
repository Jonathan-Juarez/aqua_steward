import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/deposit/domain/repositories/deposit_repository_interface.dart';

class DeleteDepositUseCase {
  final IDepositRepository repository;

  DeleteDepositUseCase(this.repository);

  // Ejecuta la eliminación del depósito inyectando el ID correspondiente.
  Future<Result<void>> call({
    required String depositId,
    required String token,
  }) {
    // Delega el borrado físico del recurso al repositorio inyectado.
    return repository.deleteDeposit(depositId: depositId, token: token);
  }
}
