import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/domain/entities/user.dart';

abstract class IAuthRepository {
  // Contrato para registrar un nuevo usuario.
  Future<Result<void>> signupUser({
    required String name,
    required String lastName,
    required String email,
    required String password,
  });

  // Contrato para iniciar sesión. Retorna el usuario autenticado envuelto en un Result.
  Future<Result<User>> signinUser({
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
    required String token,
  });

  // Contrato para eliminar un usuario por su correo electrónico.
  Future<Result<void>> deleteUser({
    required String email,
    required String token,
  });
}
