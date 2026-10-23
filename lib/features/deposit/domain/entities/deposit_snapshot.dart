import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';
import 'package:aqua_steward/features/deposit/domain/entities/sensor.dart';

// Depósito junto con sus lecturas actuales y las reglas de negocio de sus sensores.
class DepositSnapshot {
  // Orden fijo de sensores: nivel, pH y turbidez.
  static const List<String> sensorTypes = SensorTypes.all;
  static const List<String> units = ["%", "pH", "NTU"];
  static const double maxPh = 14.0;
  static const double maxTurbidity = 3000.0;

  final Deposit deposit;
  final double level;
  final double ph;
  final double turbidity;

  const DepositSnapshot({
    required this.deposit,
    this.level = 0.0,
    this.ph = 0.0,
    this.turbidity = 0.0,
  });

  double valueAt(int index) => [level, ph, turbidity][index];

  double peakAt(int index) =>
      [deposit.capacity ?? 0.0, maxPh, maxTurbidity][index];

  // Valor máximo del eje Y en la gráfica histórica (el nivel se expresa en %).
  double chartMaxAt(int index) => [100.0, maxPh, maxTurbidity][index];

  String sensorTypeAt(int index) => sensorTypes[index];

  String unitAt(int index) => units[index];

  Sensor? sensorAt(int index) => deposit.sensorOfType(sensorTypes[index]);

  bool isSensorActive(int index) => deposit.isSensorActive(sensorTypes[index]);

  // Índices de sensores activos; si no hay ninguno se muestra el nivel.
  List<int> get activeSensorIndices {
    final active = [
      for (int i = 0; i < sensorTypes.length; i++)
        if (isSensorActive(i)) i,
    ];
    return active.isNotEmpty ? active : [0];
  }

  List<String> get activeSensorTypes => deposit.activeSensorTypes;

  bool get isLevelActive => isSensorActive(0);

  // Sensores secundarios activos (pH y turbidez).
  List<int> get activeSecondaryIndices => [
    for (int i = 1; i < sensorTypes.length; i++)
      if (isSensorActive(i)) i,
  ];

  bool get hasSecondary => activeSecondaryIndices.isNotEmpty;

  // Indica si la lectura está fuera de los umbrales configurados.
  bool isOutOfRange(int index) {
    final sensor = sensorAt(index);
    final value = valueAt(index);
    final min = sensor?.minValue;
    final max = sensor?.maxValue;
    return (min != null && value < min) || (max != null && value > max);
  }

  // Proporción de llenado del indicador circular (el nivel se mide sobre 100 %).
  double progressAt(int index) {
    final peak = peakAt(index);
    if (peak == 0) return 0.0;
    return valueAt(index) / (units[index] == "%" ? 100 : peak);
  }
}
