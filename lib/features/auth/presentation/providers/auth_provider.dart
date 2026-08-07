import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/services/secure_storage_service.dart';
import 'package:aqua_steward/features/auth/data/models/user_model.dart';
import 'package:aqua_steward/features/auth/domain/entities/user.dart';
import 'package:aqua_steward/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:aqua_steward/features/auth/domain/usecases/signin_usecase.dart';
import 'package:aqua_steward/features/auth/domain/usecases/signup_usecase.dart';
import 'package:aqua_steward/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:aqua_steward/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:aqua_steward/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:aqua_steward/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter/material.dart';

// Proveedor único encargado de gestionar todo el estado y la lógica de autenticación y perfil del usuario.
class AuthProvider extends ChangeNotifier {
  final SigninUseCase _signinUseCase;
  final SignupUseCase _signupUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  // Sesión del usuario autenticado. Centraliza el estado global del usuario.
  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthProvider({
    required SigninUseCase signinUseCase,
    required SignupUseCase signupUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  }) : _signinUseCase = signinUseCase,
       _signupUseCase = signupUseCase,
       _updateUserUseCase = updateUserUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _deleteUserUseCase = deleteUserUseCase,
       _sendOtpUseCase = sendOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase;

  // Intenta restaurar la sesión guardada al abrir la aplicación.
  Future<bool> tryAutoLogin() async {
    final token = await SecureStorageService.getToken();
    final userData = await SecureStorageService.getUserData();
    if (token != null && token.isNotEmpty && userData != null) {
      try {
        _currentUser = UserModel.fromJson(userData);
        notifyListeners();
        return true;
      } catch (_) {
        await SecureStorageService.clearSession();
      }
    }
    return false;
  }

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

      // El resultado ya viene mapeado como User desde la capa de datos.
      _currentUser = result.data;
      if (_currentUser != null && _currentUser!.token != null) {
        final model = _currentUser is UserModel
            ? (_currentUser as UserModel)
            : UserModel(
                id: _currentUser!.id,
                name: _currentUser!.name,
                last_name: _currentUser!.last_name,
                email: _currentUser!.email,
                role: _currentUser!.role,
                global_role: _currentUser!.global_role,
                depositID: _currentUser!.depositID,
                token: _currentUser!.token,
              );
        await SecureStorageService.saveToken(_currentUser!.token!);
        await SecureStorageService.saveUserData(model.toJson());
      }
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
        final model = _currentUser is UserModel
            ? (_currentUser as UserModel)
            : UserModel(
                id: _currentUser!.id,
                name: _currentUser!.name,
                last_name: _currentUser!.last_name,
                email: _currentUser!.email,
                role: _currentUser!.role,
                global_role: _currentUser!.global_role,
                depositID: _currentUser!.depositID,
                token: _currentUser!.token,
              );
        await SecureStorageService.saveUserData(model.toJson());
      }
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Result<void>> deleteUser(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _deleteUserUseCase(email: email);
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Solcita el envío del código OTP al correo electrónico indicado.
  Future<Result<void>> sendOtp(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _sendOtpUseCase(email: email);
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Verifica el código OTP ingresado por el usuario.
  Future<Result<bool>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _verifyOtpUseCase(email: email, otp: otp);
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cierra la sesión activa limpiando los datos del usuario.
  Future<void> logout() async {
    _currentUser = null;
    await SecureStorageService.clearSession();
    notifyListeners();
  }
}
