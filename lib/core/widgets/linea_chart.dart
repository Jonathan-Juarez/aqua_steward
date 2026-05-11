import "package:aqua_steward/core/theme/app_padding.dart";
import "package:aqua_steward/core/widgets/container_formart.dart";
import "package:aqua_steward/core/widgets/text_format.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:aqua_steward/features/auth/presentation/providers/auth_provider.dart";
import "package:aqua_steward/features/reading/presentation/providers/reading_provider.dart";

class LineaChart extends StatefulWidget {
  final String depositId;
  final String sensorType;
  final Color color;
  final double maxY;
  final String unit;
  final String selectedFilter;

  const LineaChart({
    super.key,
    required this.depositId,
    required this.sensorType,
    required this.color,
    required this.maxY,
    required this.unit,
    required this.selectedFilter,
  });

  @override
  State<LineaChart> createState() => _LineaChartState();
}

class _LineaChartState extends State<LineaChart> {
  List<FlSpot> datosLinea = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  @override
  // Detecta cambios en el widget para recargar los datos.
  void didUpdateWidget(LineaChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recarga los datos si cambia el sensor o si cambia el filtro.
    if (oldWidget.sensorType != widget.sensorType ||
        oldWidget.selectedFilter != widget.selectedFilter) {
      setState(() {
        isLoading = true;
      });
      cargarDatos();
    }
  }

  Future<void> cargarDatos() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final readingProvider = context.read<ReadingProvider>();
      final token = authProvider.currentUser?.token ?? "";

      final result = await readingProvider.getReadings(
        widget.depositId,
        widget.sensorType,
        token,
        widget.selectedFilter,
      );

      if (result.isSuccess) {
        setState(() {
          if (mounted) {
            datosLinea = result.data!.map((reading) {
              return FlSpot(reading.index.toDouble(), reading.value.toDouble());
            }).toList();
            // debugPrint(datosLinea.toString());

            isLoading = false;
          }
        });
      } else {
        debugPrint("Error cargando lectura diaria: ${result.error}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error cargando datos del chart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isVolume = widget.unit == "%";

    return ContainerFormat(
      children: [
        isLoading
            ? const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              )
            : Padding(
                padding: AppPadding.all8,
                child: SizedBox(
                  height: 220,
                  child: LineChart(_lineChartData(isVolume)),
                ),
              ),
      ],
    );
  }

  // Grafico de linea.
  LineChartData _lineChartData(bool isVolume) {
    double maxX = 23;
    switch (widget.selectedFilter) {
      case "Dia":
        maxX = 23;
        break;
      case "Semana":
        maxX = 6; // 0 - 6 para 7 días
        break;
      case "Mes":
        maxX = 29; // 0 - 29 para 30 días
        break;
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: widget.maxY / 4,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.2),
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      ),
      titlesData: labelHourValue(isVolume),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX, // Tamaño dinámico según si es día, semana o mes.
      minY: 0,
      maxY: widget.maxY * 1.05, // Un poco de espacio arriba
      // Personalización de la línea.
      lineBarsData: [
        LineChartBarData(
          spots: datosLinea,
          isCurved: true,
          curveSmoothness: 0.2,
          color: widget.color.withOpacity(0.5),
          barWidth: 2,
          isStrokeCapRound: true,

          // Personalización de los puntos sobre la línea.
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 0.5,
                color: widget.color,
                strokeWidth: 0.5,
                strokeColor: widget.color,
              );
            },
          ),

          // Personalización de la zona debajo de la línea.
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.75),
                widget.color.withOpacity(0.5),
                widget.color.withOpacity(0.25),
                widget.color.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      // Tooltip es la caja que aparece cuando se presiona un punto.
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              Theme.of(context).colorScheme.primary,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final val = barSpot.y;
              final percent = ((val / widget.maxY) * 100).toStringAsFixed(1);
              return LineTooltipItem(
                isVolume ? "$percent%" : "$val ${widget.unit}",
                TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  FlTitlesData labelHourValue(bool isVolume) {
    return FlTitlesData(
      // Mostrar título izquierdo e inferior, ocultar el derecho y superior.
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

      // Eje x (horas/días)
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, meta) {
            final val = value.toInt();
            bool mostrar = false;
            String text = "";

            if (widget.selectedFilter == "Dia") {
              // Pares hasta el 20 (0, 2, 4... 20, 23).
              mostrar = (val % 2 == 0 && val <= 20) || val == 23;
              text = "${val}h";
            } else if (widget.selectedFilter == "Semana") {
              // Todos los días de la semana (0 a 6)
              mostrar = true;
              const dias = ["D", "L", "M", "M", "J", "V", "S"];
              if (val >= 0 && val < dias.length) {
                text = dias[val];
              }
            } else if (widget.selectedFilter == "Mes") {
              // Días del mes, ej: 1, 5, 10, 15, 20, 25, 30 (índices 0, 4, 9...)
              mostrar =
                  val == 0 ||
                  val == 4 ||
                  val == 9 ||
                  val == 14 ||
                  val == 19 ||
                  val == 24 ||
                  val == 28;
              text = "${val + 1}";
            }

            if (!mostrar || text.isEmpty) return const SizedBox.shrink();

            return TextFormat(text: text, context: context, type: "label");
          },
        ),
      ),

      // Eje y (valores o porcentajes)
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: widget.maxY / 4,
          reservedSize: 35,
          getTitlesWidget: (value, meta) {
            if (value > widget.maxY) return const SizedBox.shrink();

            String text;
            if (isVolume) {
              final percent = (value / widget.maxY * 100).round();
              text = "$percent%";
            } else {
              text = value.toString();
            }

            return TextFormat(text: text, context: context, type: "label");
          },
        ),
      ),
    );
  }
}
