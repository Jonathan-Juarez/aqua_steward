import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/data/models/user_model.dart';
import 'package:aqua_steward/features/auth/domain/usecases/signin_usecase.dart';
import 'package:aqua_steward/features/auth/domain/usecases/signup_usecase.dart';
import 'package:aqua_steward/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:aqua_steward/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:flutter/material.dart';

// Proveedor único encargado de gestionar todo el estado y la lógica de autenticación y perfil del usuario.
class AuthProvider extends ChangeNotifier {
  final SigninUseCase _signinUseCase;
  final SignupUseCase _signupUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  // Sesión del usuario autenticado. Centraliza el estado global del usuario.
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthProvider({
    required SigninUseCase signinUseCase,
    required SignupUseCase signupUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  }) : _signinUseCase = signinUseCase,
       _signupUseCase = signupUseCase,
       _updateUserUseCase = updateUserUseCase,
       _resetPasswordUseCase = resetPasswordUseCase;

  // Procesa el inicio de sesión.
  Future<Result<void>> signin({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _signinUseCase(email: email, password: password);

      if (result.isFailure) return Result.failure(result.error);

      // El resultado ya viene mapeado como UserModel desde la capa de datos.
      _currentUser = result.data;
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ejecuta el registro de un nuevo usuario.
  Future<Result<void>> signup({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _signupUseCase(
        name: name,
        lastName: lastName,
        email: email,
        password: password,
      );

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Gestiona el restablecimiento de la contraseña.
  Future<Result<void>> resetPassword(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _resetPasswordUseCase(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualiza los datos de perfil del usuario y refresca la sesión local.
  Future<Result<void>> updateUser({
    required String name,
    required String lastName,
  }) async {
    if (_currentUser == null) return Result.failure("No hay una sesión activa");

    // Evita peticiones innecesarias si los datos no han cambiado.
    if (name == _currentUser?.name && lastName == _currentUser?.last_name) {
      return Result.failure("No se detectaron cambios para actualizar");
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Limpieza de espacios en blanco y validación de campos vacíos.
      final String finalName = name.trim().isEmpty
          ? (_currentUser?.name ?? "")
          : name.trim();
      final String finalLastName = lastName.trim().isEmpty
          ? (_currentUser?.last_name ?? "")
          : lastName.trim();

      final result = await _updateUserUseCase(
        id: _currentUser!.id ?? "",
        name: finalName,
        lastName: finalLastName,
      );

      if (result.isSuccess) {
        // Actualiza el modelo local de usuario con los nuevos datos confirmados por el servidor.
        _currentUser = _currentUser!.copyWith(
          name: finalName,
          last_name: finalLastName,
        );
      }
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cierra la sesión activa limpiando los datos del usuario.
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
