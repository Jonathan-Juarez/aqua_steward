import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/api_client.dart';
import 'package:aqua_steward/features/reading/data/models/reading_model.dart';
import 'package:aqua_steward/features/reading/data/models/export_reading_model.dart';
import 'package:aqua_steward/features/reading/data/models/report_stats_model.dart';

abstract class IReadingDataSource {
  Future<Result<List<ReadingModel>>> getReadings({
    required String depositId,
    required String sensorType,
    required String token,
    required String filter,
  });

  Future<Result<List<ExportReadingModel>>> exportReadings({
    required String depositId,
    required List<String> sensorTypes,
    required String token,
    required String filter,
  });

  Future<Result<ReportStatsModel>> getReportStats({
    required String depositId,
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
  }) => ApiClient.get(
    '/api/reading/$depositId/sensor/$sensorType?filter=$filter',
    token: token,
    fromJson: (data) =>
        (data as List).map((m) => ReadingModel.fromJson(m)).toList(),
  );

  @override
  Future<Result<List<ExportReadingModel>>> exportReadings({
    required String depositId,
    required List<String> sensorTypes,
    required String token,
    required String filter,
  }) => ApiClient.get(
    '/api/reading/$depositId/export?sensors=${sensorTypes.join(',')}&filter=$filter',
    token: token,
    fromJson: (data) =>
        (data as List).map((m) => ExportReadingModel.fromJson(m)).toList(),
  );

  @override
  Future<Result<ReportStatsModel>> getReportStats({
    required String depositId,
    required String token,
    required String filter,
  }) => ApiClient.get(
    '/api/reading/$depositId/report-stats?filter=$filter',
    token: token,
    fromJson: (data) => ReportStatsModel.fromJson(data as Map<String, dynamic>),
  );
}
