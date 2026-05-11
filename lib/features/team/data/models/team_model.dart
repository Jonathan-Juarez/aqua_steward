import 'package:aqua_steward/features/team/domain/entities/team.dart';

class TeamModel extends Team {
  const TeamModel({
    super.id,
    super.email,
    super.name,
    super.last_name,
    super.role,
    super.status,
  });

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      id: map['user_id'] ?? map['id'],
      email: map['email'],
      name: map['name'],
      last_name: map['last_name'],
      role: map['role'],
      status: map['status'],
    );
  }
}
