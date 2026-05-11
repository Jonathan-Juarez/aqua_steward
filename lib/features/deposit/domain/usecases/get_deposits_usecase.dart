import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/deposit/domain/repositories/deposit_repository_interface.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';

class GetDepositsUseCase {
  final IDepositRepository repository;

  GetDepositsUseCase(this.repository);

  // Ejecuta la recuperación de la lista de depósitos disponibles para el usuario.
  Future<Result<List<Deposit>>> call({required String token}) {
    // Retorna la colección de depósitos a través del repositorio de dominio.
    return repository.getDeposits(token: token);
  }
}
