class ComplianceStat {
  final String sensorType;
  final double percentage;
  final int totalReadings;
  final int inRange;

  const ComplianceStat({
    required this.sensorType,
    required this.percentage,
    required this.totalReadings,
    required this.inRange,
  });
}

class ReportAlertItem {
  final String id;
  final DateTime date;
  final String type;
  final String description;
  final double? triggerValue;

  const ReportAlertItem({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    this.triggerValue,
  });
}

class ReportAlertsData {
  final int totalAlerts;
  final Map<String, int> countByType;
  final List<ReportAlertItem> alerts;

  const ReportAlertsData({
    required this.totalAlerts,
    required this.countByType,
    required this.alerts,
  });
}

class ReportStats {
  final List<ComplianceStat> compliance;
  final ReportAlertsData alerts;

  const ReportStats({
    required this.compliance,
    required this.alerts,
  });
}
