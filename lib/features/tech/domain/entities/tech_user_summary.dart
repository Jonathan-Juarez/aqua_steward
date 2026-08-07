class TechUserSummary {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String global_role;
  final int assignedDepositsCount;

  const TechUserSummary({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.global_role,
    required this.assignedDepositsCount,
  });

  factory TechUserSummary.fromMap(Map<String, dynamic> map) {
    return TechUserSummary(
      id: map["id"] as String? ?? "",
      name: map["name"] as String? ?? "",
      lastName: map["last_name"] as String? ?? "",
      email: map["email"] as String? ?? "",
      global_role: map["global_role"] as String? ?? "user",
      assignedDepositsCount:
          (map["assignedDepositsCount"] as num?)?.toInt() ?? 0,
    );
  }
}
