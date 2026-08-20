import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/api_client.dart';

abstract class ITechDataSource {
  Future<Result<Map<String, dynamic>>> getSystemStats({required String token});
  Future<Result<List<dynamic>>> getAllUsers({required String token});
}

class TechDataSourceImpl implements ITechDataSource {
  @override
  Future<Result<Map<String, dynamic>>> getSystemStats({
    required String token,
  }) => ApiClient.get(
    '/api/tech/stats',
    token: token,
    fromJson: (data) => data as Map<String, dynamic>,
  );

  @override
  Future<Result<List<dynamic>>> getAllUsers({required String token}) =>
      ApiClient.get(
        '/api/tech/users',
        token: token,
        fromJson: (data) => data as List<dynamic>,
      );
}
