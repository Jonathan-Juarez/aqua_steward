import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/reading/domain/entities/reading.dart';
import 'package:aqua_steward/features/reading/domain/usecases/get_daily_readings_usecase.dart';
import 'package:flutter/material.dart';

class ReadingProvider extends ChangeNotifier {
  final GetReadingsUseCase getReadingsUseCase;

  ReadingProvider({required this.getReadingsUseCase});

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
}
