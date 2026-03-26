import "dart:convert";
import "package:aqua_steward/core/theme/app_sizedbox.dart";
import "package:aqua_steward/core/theme/app_circular_progress.dart";
import "package:aqua_steward/core/theme/app_text.dart";
import "package:aqua_steward/core/widgets/container_formart.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart" show rootBundle;

class ParameterChart extends StatefulWidget {
  final String asset;
  final String titleParameter;
  final Color color;
  final double maxY;
  final String unit;

  const ParameterChart({
    super.key,
    required this.asset,
    required this.titleParameter,
    required this.color,
    required this.maxY,
    required this.unit,
  });

  @override
  State<ParameterChart> createState() => _ParameterChartState();
}

class _ParameterChartState extends State<ParameterChart> {
  List<FlSpot> datosLinea = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final jsonStr = await rootBundle.loadString(widget.asset);
      final data = json.decode(jsonStr) as List<dynamic>;

      if (!mounted) return;

      setState(() {
        // Línea: Usamos TODOS los datos (0..23) para tener interacción completa
        datosLinea = data.map((e) {
          return FlSpot(
            (e["hora"] as int).toDouble(),
            (e["valor"] as num).toDouble(),
          );
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error cargando datos del chart: $e");
    }
  }

  LinearGradient _getLineGradient(Color color) {
    return LinearGradient(
      colors: [color.withOpacity(0.5), color],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isVolume = widget.unit == "L";

    return ContainerFormat(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.titleParameter,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Indicador opcional si es volumen
                if (isVolume)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Capacidad",
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            AppSizedBox.height16,
            isLoading
                ? const SizedBox(
                    height: 200,
                    child: Center(
                      child: AppCircularProgress.circularProgressFormat,
                    ),
                  )
                : SizedBox(
                    height: 220,
                    child: LineChart(_lineChartData(isVolume)),
                  ),
          ],
        ),
      ],
    );
  }

  // Grafico de linea.
  LineChartData _lineChartData(bool isVolume) {
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
      maxX: 23, // Cubre hasta las 23h
      minY: 0,
      maxY: widget.maxY * 1.1, // Un poco de espacio arriba
      lineBarsData: [
        LineChartBarData(
          spots: datosLinea,
          isCurved: true,
          gradient: _getLineGradient(widget.color),
          barWidth: 4,
          isStrokeCapRound: true,

          // Personalización de los puntos sobre la línea.
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 1.5,
                color: Colors.blue[500]!,
                strokeWidth: 1,
                strokeColor: widget.color,
              );
            },
          ),

          // Personalización de la zona debajo de la línea.
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.5), // Un poco más visible
                widget.color.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // CORRECCIÓN para fl_chart 1.1.1: Usar getTooltipColor
          getTooltipColor: (touchedSpot) => Colors.black87,
          // Se eliminó tooltipRoundedRadius para evitar conflictos de versión
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final val = barSpot.y;
              final percent = ((val / widget.maxY) * 100).toStringAsFixed(1);
              return LineTooltipItem(
                isVolume
                    ? "${val.toInt()} ${widget.unit}\n($percent%)"
                    : "$val ${widget.unit}",
                const TextStyle(
                  color: Colors.white,
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
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

      // Eje Inferior (Horas)
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval:
              1, // Evaluamos cada número para aplicar la lógica personalizada
          getTitlesWidget: (value, meta) {
            final hora = value.toInt();

            // Lógica personalizada solicitada: Pares hasta el 20 (0, 2, 4... 20, 23)
            bool mostrar = (hora % 2 == 0 && hora <= 20) || hora == 23;

            if (!mostrar) return const SizedBox.shrink();

            // Muestra la hora (eje x).
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("${hora}h", style: AppText.graph),
            );
          },
        ),
      ),

      // Eje Izquierdo (Valores o Porcentajes)
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
              text = value >= 10
                  ? value.toStringAsFixed(0)
                  : value.toStringAsFixed(1);
            }
            // Muestra el porcentaje o valor (eje y).

            return Text(text, style: AppText.graph, textAlign: TextAlign.left);
          },
        ),
      ),
    );
  }
}
