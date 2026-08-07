class User {
  final String? id;
  final String? name;
  final String? last_name;
  final String? email;
  final String? password;
  final String? role;
  final String? global_role;
  final String? depositID;
  final String? token;

  const User({
    this.id,
    this.name,
    this.last_name,
    this.email,
    this.password,
    this.role,
    this.global_role,
    this.depositID,
    this.token,
  });

  User copyWith({
    String? id,
    String? name,
    String? last_name,
    String? email,
    String? password,
    String? role,
    String? global_role,
    String? depositID,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      last_name: last_name ?? this.last_name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      global_role: global_role ?? this.global_role,
      depositID: depositID ?? this.depositID,
      token: token ?? this.token,
    );
  }
}
