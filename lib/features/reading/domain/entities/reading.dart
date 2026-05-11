class Reading {
  final int? hour;
  final int? day;
  final double value;

  Reading({this.hour, this.day, required this.value});

  int get index => (hour ?? day) ?? 0;
}
