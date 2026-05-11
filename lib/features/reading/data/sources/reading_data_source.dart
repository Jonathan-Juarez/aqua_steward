import 'dart:convert';
import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/global_variable.dart';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:aqua_steward/core/error/exception_handler.dart';
import 'package:aqua_steward/features/reading/data/models/reading_model.dart';
import 'package:http/http.dart' as http;

abstract class IReadingDataSource {
  Future<Result<List<ReadingModel>>> getReadings({
    required String depositId,
    required String sensorType,
    required String token,
    required String filter,
  });
}

class ReadingDataSourceImpl implements IReadingDataSource {
  @override
  Future<Result<List<ReadingModel>>> getReadings({
    required String depositId,
    required String sensorType,
    required String token,
    required String filter,
  }) async {
    try {
      // filter es para filtrar las lecturas por día, semana o mes.
      final http.Response response = await http.get(
        Uri.parse(
          "$uri/api/reading/$depositId/sensor/$sensorType?filter=$filter",
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );
      final result = manageHttpResponse(response: response);
      if (result.isSuccess) {
        // Se decodifica el JSON y se mapea a una lista de ReadingModel.
        final List<dynamic> data = json.decode(response.body);
        final list = data
            .map((readingMap) => ReadingModel.fromJson(readingMap))
            .toList();
        return Result.success(list);
      } else {
        return Result.failure(result.error);
      }
    } catch (e) {
      return handleException(e);
    }
  }
}
