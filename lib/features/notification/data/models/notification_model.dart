import 'package:aqua_steward/features/notification/domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    required super.date,
    super.state,
    super.depositId,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate;
    if (map['date'] != null) {
      String dateStr = map['date'].toString();
      if (!dateStr.endsWith('Z') && !dateStr.contains('+') && !dateStr.contains('-')) {
        dateStr += 'Z';
      }
      parsedDate = DateTime.parse(dateStr).toLocal();
    } else {
      parsedDate = DateTime.now();
    }

    return NotificationModel(
      id: (map['id'] ?? map['_id'])?.toString() ?? '',
      title: map['title']?.toString() ?? 'Alerta',
      message: map['message']?.toString() ?? '',
      type: map['type']?.toString() ?? 'General',
      date: parsedDate,
      state: map['state']?.toString(),
      depositId: map['deposit_id']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'date': date.toIso8601String(),
      'state': state,
      'deposit_id': depositId,
    };
  }
}
