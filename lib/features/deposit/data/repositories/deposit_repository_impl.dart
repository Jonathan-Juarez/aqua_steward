import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/deposit/data/models/deposit_model.dart';
import 'package:aqua_steward/features/deposit/data/sources/deposit_data_source.dart';
import 'package:aqua_steward/features/deposit/domain/repositories/deposit_repository_interface.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';

class DepositRepositoryImpl implements IDepositRepository {
  final IDepositDataSource dataSource;

  DepositRepositoryImpl(this.dataSource);

  @override
  // Delega la obtención de depósitos a la fuente de datos externa.
  Future<Result<List<Deposit>>> getDeposits({required String token}) async {
    // Captura el mapa de datos original desde el DataSource.
    final result = await dataSource.getAll(token: token);
    if (result.isSuccess) {
      // Procesa y transforma la lista de mapas genéricos en modelos DepositModel.
      final List<dynamic> data = result.data!;
      final deposits = data.map((e) => DepositModel.fromMap(e)).toList();
      // Retorna éxito con la lista final de objetos de la entidad.
      return Result.success(deposits);
    } else {
      // Propaga el error específico encontrado durante la consulta.
      return Result.failure(result.error);
    }
  }

  @override
  // Delega la creación de un nuevo depósito al repositorio de datos.
  Future<Result<void>> createDeposit({
    required DepositModel deposit,
    required String token,
  }) {
    // Retorna directamente el resultado procesado por el DataSource inyectado.
    return dataSource.create(deposit: deposit, token: token);
  }

  @override
  // Delega la eliminación del depósito específico a la capa de datos.
  Future<Result<void>> deleteDeposit({
    required String depositId,
    required String token,
  }) {
    // Realiza la petición técnica a la fuente de datos de red persistente.
    return dataSource.delete(depositId: depositId, token: token);
  }

  @override
  Future<Result<void>> updateDeposit({
    required String depositId,
    required String token,
    required DepositModel deposit,
  }) {
    return dataSource.update(
      depositId: depositId,
      token: token,
      deposit: deposit,
    );
  }
}
