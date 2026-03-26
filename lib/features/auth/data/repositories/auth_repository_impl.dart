import 'package:aqua_steward/features/auth/data/datasources/auth_data_source.dart';
import 'package:aqua_steward/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutter/material.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    // Delegamos la petición a la fuente de datos externa de la red.
    return dataSource.resetPassword(
      context: context,
      email: email,
      password: password,
    );
  }
}
