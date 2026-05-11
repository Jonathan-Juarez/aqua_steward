import 'dart:convert';
import 'package:aqua_steward/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    super.id,
    super.name,
    super.last_name,
    super.email,
    super.password,
    super.role,
    super.depositID,
    super.token,
  });

  // El método copyWith crea una copia del usuario, permitiendo actualizar campos específicos sin perder el resto de datos.
  UserModel copyWith({
    String? id,
    String? name,
    String? last_name,
    String? email,
    String? password,
    String? role,
    String? depositID,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      last_name: last_name ?? this.last_name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      depositID: depositID ?? this.depositID,
      token: token ?? this.token,
    );
  }

  // Serializa solo el contenido no nulo para permitir actualizaciones parciales en el backend y evitar sobrescribir datos existentes con null.
  Map<String, String> toMap() {
    return {
      if (id != null) "id": id!,
      if (name != null) "name": name!,
      if (last_name != null) "last_name": last_name!,
      if (email != null) "email": email!,
      if (password != null) "password": password!,
      if (role != null) "role": role!,
      if (depositID != null) "depositID": depositID!,
      if (token != null) "token": token!,
    };
  }

  // Serializar, convirtiendo el mapa a un string json. Es decir, la codificación.
  String toJson() => json.encode(toMap());

  // Deserializar, convirtiendo un mapa a un objeto UserModel.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map["_id"] ?? map["id"]) as String? ?? "",
      name: map["name"] as String? ?? "",
      last_name: map["last_name"] as String? ?? "",
      email: map["email"] as String? ?? "",
      password: map["password"] as String? ?? "",
      role: map["role"] as String? ?? "",
      depositID: map["depositID"] as String? ?? "",
      token: map["token"] as String? ?? "",
    );
  }

  // La decodificación.
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
