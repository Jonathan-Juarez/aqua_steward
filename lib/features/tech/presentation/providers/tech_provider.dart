import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/tech/domain/entities/system_stats.dart';
import 'package:aqua_steward/features/tech/domain/entities/tech_user_summary.dart';
import 'package:aqua_steward/features/tech/domain/usecases/get_all_users_tech_usecase.dart';
import 'package:aqua_steward/features/tech/domain/usecases/get_system_stats_usecase.dart';
import 'package:flutter/material.dart';

class TechProvider extends ChangeNotifier {
  final GetSystemStatsUseCase getSystemStatsUseCase;
  final GetAllUsersTechUseCase getAllUsersTechUseCase;

  TechProvider({
    required this.getSystemStatsUseCase,
    required this.getAllUsersTechUseCase,
  });

  SystemStats? _stats;
  SystemStats? get stats => _stats;

  List<TechUserSummary> _users = [];
  List<TechUserSummary> get users => _users;

  bool _isLoadingStats = false;
  bool get isLoadingStats => _isLoadingStats;

  bool _isLoadingUsers = false;
  bool get isLoadingUsers => _isLoadingUsers;

  Future<Result<SystemStats>> loadStats({required String token}) async {
    _isLoadingStats = true;
    notifyListeners();

    try {
      final result = await getSystemStatsUseCase.call(token: token);
      if (result.isSuccess) {
        _stats = result.data;
      }
      return result;
    } finally {
      _isLoadingStats = false;
      notifyListeners();
    }
  }

  Future<Result<List<TechUserSummary>>> loadUsers({required String token}) async {
    _isLoadingUsers = true;
    notifyListeners();

    try {
      final result = await getAllUsersTechUseCase.call(token: token);
      if (result.isSuccess) {
        _users = result.data!;
      }
      return result;
    } finally {
      _isLoadingUsers = false;
      notifyListeners();
    }
  }
}
