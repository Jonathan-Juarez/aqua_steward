import 'dart:convert';
import 'dart:io';
import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/reading/domain/entities/reading.dart';
import 'package:aqua_steward/features/reading/domain/entities/report_stats.dart';
import 'package:aqua_steward/features/reading/domain/usecases/get_daily_readings_usecase.dart';
import 'package:aqua_steward/features/reading/domain/usecases/export_readings_usecase.dart';
import 'package:aqua_steward/features/reading/domain/usecases/get_reading_report_stats_usecase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReadingProvider extends ChangeNotifier {
  final GetReadingsUseCase getReadingsUseCase;
  final ExportReadingsUseCase exportReadingsUseCase;
  final GetReadingReportStatsUseCase getReportStatsUseCase;

  ReadingProvider({
    required this.getReadingsUseCase,
    required this.exportReadingsUseCase,
    required this.getReportStatsUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Result<List<Reading>>> getReadings(
    String depositId,
    String sensorType,
    String token,
    String filter,
  ) async {
    _isLoading = true;
    // Se evita notificar si el widget todavía se está construyendo para no causar error.
    Future.microtask(() => notifyListeners());

    try {
      final result = await getReadingsUseCase.call(
        depositId: depositId,
        sensorType: sensorType,
        token: token,
        filter: filter,
      );
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Result<void>> exportReadings({
    required String depositId,
    required List<String> sensorTypes,
    required String token,
    required String depositName,
    required String filter,
  }) async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    try {
      final result = await exportReadingsUseCase.call(
        depositId: depositId,
        sensorTypes: sensorTypes,
        token: token,
        filter: filter,
      );

      if (result.isSuccess) {
        final readings = result.data!;
        if (readings.isEmpty) {
          return Result.failure("No hay datos para exportar");
        }

        final csvBuffer = StringBuffer();
        // Cabeceras legibles
        csvBuffer.writeln('Fecha y Hora,Valor,Unidad,Sensor,Deposito');

        final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        for (final r in readings) {
          final dateStr = dateFormat.format(r.timestamp.toLocal());
          // Evitamos problemas con comas en el nombre del depósito
          csvBuffer.writeln(
            '"$dateStr",${r.value},"${r.unit}","${r.sensorType}","${r.depositName}"',
          );
        }

        final tempDir = await getTemporaryDirectory();
        // Se elimina cualquier carácter que no sea alfanumérico o espacio y se reemplazan los espacios por guiones bajos.
        final sanitizedDepositName = depositName
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .replaceAll(' ', '_');
        final file = File(
          '${tempDir.path}/${sanitizedDepositName}_lecturas.csv',
        );
        await file.writeAsString(csvBuffer.toString(), encoding: utf8);

        await Share.shareXFiles([XFile(file.path)]);
        return Result.success(null);
      } else {
        return Result.failure(result.error);
      }
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Result<ReportStats>> getReportStats({
    required String depositId,
    required String token,
    required String filter,
  }) async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    try {
      final result = await getReportStatsUseCase.call(
        depositId: depositId,
        token: token,
        filter: filter,
      );
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
