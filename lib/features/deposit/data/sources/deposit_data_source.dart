import 'dart:convert';

import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/global_variable.dart';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:aqua_steward/core/error/exception_handler.dart';
import 'package:aqua_steward/features/deposit/data/models/deposit_model.dart';
import 'package:http/http.dart' as http;

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
  Future<Result<List<dynamic>>> getAll({required String token}) async {
    try {
      // Ejecuta la petición GET inyectando el token de autenticación en las cabeceras.
      final http.Response response = await http.get(
        Uri.parse("$uri/api/deposit/getDeposits"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      // Procesa la respuesta mediante el manejador centralizado de HTTP.
      final result = manageHttpResponse(response: response);
      if (result.isSuccess) {
        // Retorna la lista dinámica decodificada desde el cuerpo de la respuesta.
        return Result.success(json.decode(response.body));
      } else {
        // Propaga el error capturado por el manejador de respuestas.
        return Result.failure(result.error);
      }
    } catch (e) {
      // Captura excepciones de red o tiempo de espera durante la consulta.
      return handleException(e);
    }
  }

  @override
  // Ejecuta el registro de un nuevo depósito en el sistema mediante HTTP POST.
  Future<Result<void>> create({
    required DepositModel deposit,
    required String token,
  }) async {
    try {
      // Envía los datos del depósito codificados en JSON al servidor central.
      final http.Response response = await http.post(
        Uri.parse("$uri/api/deposit/createDeposit"),
        body: deposit.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      // Retorna el resultado directo de la gestión de la respuesta HTTP.
      return manageHttpResponse(response: response);
    } catch (e) {
      // Maneja errores inesperados de comunicación en la creación.
      return handleException(e);
    }
  }

  @override
  // Realiza la eliminación de un depósito por su identificador único vía HTTP DELETE.
  Future<Result<void>> delete({
    required String depositId,
    required String token,
  }) async {
    try {
      // Ejecuta la acción de borrado en el endpoint correspondiente al ID dado.
      final http.Response response = await http.delete(
        Uri.parse("$uri/api/deposit/deleteDeposit/$depositId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      // Valida y retorna el éxito o fallo de la operación de borrado.
      return manageHttpResponse(response: response);
    } catch (e) {
      // Retorna la descripción del error técnico tras el fallo en la eliminación.
      return handleException(e);
    }
  }

  @override
  // Actualiza un depósito existente en el sistema mediante HTTP PUT.
  Future<Result<void>> update({
    required String depositId,
    required String token,
    required DepositModel deposit,
  }) async {
    try {
      // Envía los datos del depósito codificados en JSON al servidor central.
      final http.Response response = await http.put(
        Uri.parse("$uri/api/deposit/updateDeposit/$depositId"),
        body: deposit.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      // Retorna el resultado directo de la gestión de la respuesta HTTP.
      return manageHttpResponse(response: response);
    } catch (e) {
      // Maneja errores inesperados de comunicación en la actualización.
      return handleException(e);
    }
  }
}
