class Notification {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime date;
  final String? state;
  final String? depositId;

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.state,
    this.depositId,
  });
}
