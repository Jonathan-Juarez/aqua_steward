class AppValidators {
  // Validador para campos requeridos
  static String? validateRequired(String? value) {
    return value == null || value.trim().isEmpty ? "Campo requerido" : null;
  }

  //Valiador de campos únicos.
  static String? validateUnique(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nº";
    }
    return null;
  }

  // Validador de correo electrónico
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Campo requerido";
    }
    // Expresión regular básica para validar email
    final emailRegex = RegExp(
      r"^[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+",
    );
    // Si el correo no cumple con la expresión regular, devuelve un mensaje de error.
    return !emailRegex.hasMatch(value) ? "Correo inválido" : null;
  }

  // Validador de contraseña
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Campo requerido";
    }
    final passwordRegex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$",
    );
    if (value.length < 8 && !passwordRegex.hasMatch(value)) {
      return "La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial";
    }
    return null;
  }

  // Validador de IP.
  static String? validateIP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Campo requerido";
    }
    final ipRegex = RegExp(
      r"^((25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)(\.)){3}(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$",
    );
    return !ipRegex.hasMatch(value) ? "IP inválida" : null;
  }
}
