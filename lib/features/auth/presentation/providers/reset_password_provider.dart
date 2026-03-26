import 'package:aqua_steward/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:flutter/material.dart';

class ResetPasswordProvider extends ChangeNotifier {
  final ResetPasswordUseCase _resetPasswordUseCase;

  // Este controlador conserva la contraseña insertada por el usuario en el input de la UI.
  final TextEditingController passwordController = TextEditingController();

  // Estado local para manejar visualmente el indicador de carga del botón de la UI.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Constructor explícito para inyectar nuestra regla de negocio (Dominio).
  ResetPasswordProvider({required ResetPasswordUseCase resetPasswordUseCase})
    : _resetPasswordUseCase = resetPasswordUseCase;

  /// Inicia el flujo comunicándose con la capa de Dominio, reaccionando para la vista.
  Future<void> resetPassword(BuildContext context, String email) async {
    _isLoading = true;
    notifyListeners(); // Llama a redibujar a los escuchadores (Consumer) para mostrar la carga

    try {
      // Accede al caso de uso de Dominio con total autonomía técnica del backend de datos.
      await _resetPasswordUseCase.call(
        context: context,
        email: email,
        password: passwordController.text,
      );
    } catch (e) {
      debugPrint("Error no controlado en la vista: \${e.toString()}");
    } finally {
      // Retiramos el estado de carga aunque falle.
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
