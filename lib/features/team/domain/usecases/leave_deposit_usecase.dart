import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/repositories/team_repository_interface.dart';

// Caso de Uso que encapsula la lógica para que un miembro abandone un depósito.
class LeaveDepositUseCase {
  final ITeamRepository repository;

  LeaveDepositUseCase(this.repository);

  // Ejecuta la salida del depósito delegando al repositorio.
  Future<Result<void>> call({
    required String depositId,
    required String token,
  }) {
    return repository.leaveDeposit(
      depositId: depositId,
      token: token,
    );
  }
}
