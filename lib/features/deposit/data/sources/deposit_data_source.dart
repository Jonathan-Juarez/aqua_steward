import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/api_client.dart';
import 'package:aqua_steward/features/deposit/data/models/deposit_model.dart';

abstract class IDepositDataSource {
  // Contrato para la petición de red que obtiene la lista de depósitos.
  Future<Result<List<void>>> getAll({required String token});

  // Contrato para la petición de red que registra un nuevo depósito.
  Future<Result<void>> create({
    required DepositModel deposit,
    required String token,
  });

  // Contrato para la petición de red que elimina un depósito.
  Future<Result<void>> delete({
    required String depositId,
    required String token,
  });

  // Contrato para la petición de red que actualiza un depósito.
  Future<Result<void>> update({
    required String depositId,
    required String token,
    required DepositModel deposit,
  });
}

class DepositDataSourceImpl implements IDepositDataSource {
  @override
  // Realiza la petición HTTP GET para obtener los depósitos del usuario actual.
  Future<Result<List<dynamic>>> getAll({required String token}) =>
      ApiClient.get(
        '/api/deposit/getDeposits',
        token: token,
        fromJson: (data) => data as List<dynamic>,
      );

  @override
  // Ejecuta el registro de un nuevo depósito en el sistema mediante HTTP POST.
  Future<Result<void>> create({
    required DepositModel deposit,
    required String token,
  }) => ApiClient.post(
    '/api/deposit/createDeposit',
    token: token,
    body: deposit.toMap(),
  );

  @override
  // Realiza la eliminación de un depósito por su identificador único vía HTTP DELETE.
  Future<Result<void>> delete({
    required String depositId,
    required String token,
  }) => ApiClient.delete('/api/deposit/deleteDeposit/$depositId', token: token);

  @override
  // Actualiza un depósito existente en el sistema mediante HTTP PUT.
  Future<Result<void>> update({
    required String depositId,
    required String token,
    required DepositModel deposit,
  }) => ApiClient.put(
    '/api/deposit/updateDeposit/$depositId',
    token: token,
    body: deposit.toMap(),
  );
}
