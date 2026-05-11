import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/data/models/user_model.dart';

abstract class IAuthRepository {
  // Contrato para registrar un nuevo usuario.
  Future<Result<void>> signupUser({
    required String name,
    required String lastName,
    required String email,
    required String password,
  });

  // Contrato para iniciar sesión. Retorna el usuario autenticado envuelto en un Result.
  Future<Result<UserModel>> signinUser({
    required String email,
    required String password,
  });

  // Contrato para restablecer la contraseña en la capa de dominio.
  Future<Result<void>> resetPassword({
    required String email,
    required String password,
  });

  // Contrato para actualizar la información de perfil del usuario.
  Future<Result<void>> updateUser({
    required String id,
    String? name,
    String? lastName,
  });
}
