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
      id: (map['user_id'] ?? map['id'])?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      last_name: map['last_name']?.toString() ?? '',
      role: map['role']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',
    );
  }
}
