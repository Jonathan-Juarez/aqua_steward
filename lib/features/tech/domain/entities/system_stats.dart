class SystemStats {
  final int totalUsers;
  final int totalDeposits;
  final int distanceSensors;
  final int phSensors;
  final int turbiditySensors;

  const SystemStats({
    required this.totalUsers,
    required this.totalDeposits,
    required this.distanceSensors,
    required this.phSensors,
    required this.turbiditySensors,
  });

  factory SystemStats.fromMap(Map<String, dynamic> map) {
    final sensorMap = map["activeSensors"] as Map<String, dynamic>? ?? {};

    return SystemStats(
      totalUsers: (map["totalUsers"] as num?)?.toInt() ?? 0,
      totalDeposits: (map["totalDeposits"] as num?)?.toInt() ?? 0,
      distanceSensors: (sensorMap["distance"] as num?)?.toInt() ?? 0,
      phSensors: (sensorMap["ph"] as num?)?.toInt() ?? 0,
      turbiditySensors: (sensorMap["turbidity"] as num?)?.toInt() ?? 0,
    );
  }
}
