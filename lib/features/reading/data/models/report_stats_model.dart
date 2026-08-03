import 'package:aqua_steward/features/reading/domain/entities/report_stats.dart';

class ComplianceStatModel extends ComplianceStat {
  const ComplianceStatModel({
    required super.sensorType,
    required super.percentage,
    required super.totalReadings,
    required super.inRange,
  });

  factory ComplianceStatModel.fromJson(Map<String, dynamic> json) {
    return ComplianceStatModel(
      sensorType: json['sensorType'] ?? '',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 100.0,
      totalReadings: (json['totalReadings'] as num?)?.toInt() ?? 0,
      inRange: (json['inRange'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReportAlertItemModel extends ReportAlertItem {
  const ReportAlertItemModel({
    required super.id,
    required super.date,
    required super.type,
    required super.description,
    super.triggerValue,
  });

  factory ReportAlertItemModel.fromJson(Map<String, dynamic> json) {
    return ReportAlertItemModel(
      id: json['id'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date']).toLocal()
          : DateTime.now(),
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      triggerValue: (json['triggerValue'] as num?)?.toDouble(),
    );
  }
}

class ReportAlertsDataModel extends ReportAlertsData {
  const ReportAlertsDataModel({
    required super.totalAlerts,
    required super.countByType,
    required super.alerts,
  });

  factory ReportAlertsDataModel.fromJson(Map<String, dynamic> json) {
    final countByTypeRaw = json['countByType'] as Map<String, dynamic>? ?? {};
    final countMap = <String, int>{};
    countByTypeRaw.forEach((key, value) {
      countMap[key] = (value as num).toInt();
    });

    final alertsRaw = (json['alerts'] as List<dynamic>?) ?? [];
    final alertsList = alertsRaw
        .map((a) => ReportAlertItemModel.fromJson(a as Map<String, dynamic>))
        .toList();

    return ReportAlertsDataModel(
      totalAlerts: (json['totalAlerts'] as num?)?.toInt() ?? 0,
      countByType: countMap,
      alerts: alertsList,
    );
  }
}

class ReportStatsModel extends ReportStats {
  const ReportStatsModel({
    required super.compliance,
    required super.alerts,
  });

  factory ReportStatsModel.fromJson(Map<String, dynamic> json) {
    final complianceRaw = (json['compliance'] as List<dynamic>?) ?? [];
    final complianceList = complianceRaw
        .map((c) => ComplianceStatModel.fromJson(c as Map<String, dynamic>))
        .toList();

    final alertsObj = json['alerts'] as Map<String, dynamic>? ?? {};
    final alertsData = ReportAlertsDataModel.fromJson(alertsObj);

    return ReportStatsModel(
      compliance: complianceList,
      alerts: alertsData,
    );
  }
}
