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

  // Serializar el objeto UserModel. Se convierte un objeto UserModel en un Map<String, dynamic>.
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "last_name": last_name,
      "email": email,
      "password": password,
      "role": role,
      "depositID": depositID,
      "token": token,
    };
  }

  // Serializar, convirtiendo el mapa a un string json. Es decir, la codificación.
  String toJson() => json.encode(toMap());

  // Deserializar, convirtiendo un mapa a un objeto UserModel.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["_id"] as String? ?? "",
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
