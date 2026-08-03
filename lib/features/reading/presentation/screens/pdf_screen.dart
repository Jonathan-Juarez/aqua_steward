import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/extensions/to_clean_string.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import 'package:aqua_steward/features/reading/domain/entities/report_stats.dart';

class PdfScreen extends StatelessWidget {
  final Map<String, dynamic> dataPdf;

  const PdfScreen({super.key, required this.dataPdf});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_vista_previa_pdf,
      children: [
        AppSizedBox.height12,
        // Contenedor del visor
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.84,
          child: PdfPreview(
            build: (format) => _generatePdf(dataPdf),
            // Apaga la barra de herramientas fea por defecto
            useActions: true,
            pdfFileName: '${dataPdf["filename"]}.pdf',
            // Desactiva la opción de cambiar orientación.
            canChangeOrientation: false,
            // Desactiva la opción de cambiar formato de página.
            canChangePageFormat: false,
            // Desactiva la opción de depuración.
            canDebug: false,
            // Decoración del contenedor del visor.
            scrollViewDecoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),

            pdfPreviewPageDecoration: const BoxDecoration(
              color: AppColor.white, // Fondo del papel
              borderRadius: AppBorder.all8,
              boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4)],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildAlertKpiCard(String label, String count, String colorHex) {
    return pw.Container(
      width: 110,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F8FAFC'),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: PdfColor.fromHex(colorHex), width: 1),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            count,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex(colorHex),
            ),
          ),
        ],
      ),
    );
  }

  // Genera el PDF con la configuración seleccionada. Uint8List es un tipo de dato que representa una lista de bytes, que es lo que necesita la librería pdf.
  Future<Uint8List> _generatePdf(Map<String, dynamic> dataPdf) async {
    final pdf = pw.Document();
    final List<Uint8List?> chartsImages =
        (dataPdf["chartsImages"] as List<dynamic>?)?.cast<Uint8List?>() ?? [];

    final depositData = dataPdf["depositData"] as Map<String, dynamic>? ?? {};
    final depositName = depositData["name"] ?? "Desconocido";
    final depositIp = depositData["ip"] ?? "Sin IP";
    final depositCapacity = depositData["capacity"] ?? 0;
    final ReportStats? reportStats = dataPdf["reportStats"] as ReportStats?;

    String getDateRangeText(String? filter) {
      final now = DateTime.now();
      final formatter = DateFormat('dd/MM/yyyy');
      if (filter == "Dia" || filter == "Día") {
        return formatter.format(now);
      } else if (filter == "Semana") {
        final start = now.subtract(const Duration(days: 7));
        return "${formatter.format(start)} - ${formatter.format(now)}";
      } else if (filter == "Mes") {
        final start = now.subtract(const Duration(days: 30));
        return "${formatter.format(start)} - ${formatter.format(now)}";
      }
      return filter ?? "";
    }

    final dateRange = getDateRangeText(dataPdf["selectedFilter"]);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 8),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColor.fromHex('#4A90E2'),
                    width: 2,
                  ),
                ),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'AquaSteward - Reporte de Monitoreo',
                        style: pw.TextStyle(
                          color: PdfColor.fromHex('#4A90E2'),
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Depósito: $depositName',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Período:',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.Text(
                        dateRange,
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 12),

            // Información del depósito (Capacidad y IP centradas)
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F5F5F5'),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(
                        'Capacidad',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        '$depositCapacity L',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(
                        'IP Conexión',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        depositIp,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tendencias de Sensores
            if (dataPdf["includeStats"] == true) ...[
              pw.SizedBox(height: 16),
              pw.Text(
                'Estadísticas y Tendencias de Sensores',
                style: pw.TextStyle(
                  color: PdfColor.fromHex('#4A90E2'),
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              if (chartsImages.isNotEmpty && chartsImages[0] != null) ...[
                pw.Text(
                  "Nivel (HC-SR04)",
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(chartsImages[0]!),
                    width: 480,
                    height: 140,
                  ),
                ),
              ],
              if (chartsImages.length > 1 && chartsImages[1] != null) ...[
                pw.SizedBox(height: 12),
                pw.Text(
                  "pH (PH-4502C)",
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(chartsImages[1]!),
                    width: 480,
                    height: 140,
                  ),
                ),
              ],
              if (chartsImages.length > 2 && chartsImages[2] != null) ...[
                pw.SizedBox(height: 12),
                pw.Text(
                  "Turbidez (TS300B)",
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(chartsImages[2]!),
                    width: 480,
                    height: 140,
                  ),
                ),
              ],
            ],

            // Porcentaje de Cumplimiento
            if (dataPdf["includeCompliance"] == true &&
                reportStats != null) ...[
              pw.SizedBox(height: 16),
              pw.Text(
                'Porcentaje de Cumplimiento de Umbrales',
                style: pw.TextStyle(
                  color: PdfColor.fromHex('#4A90E2'),
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F9FAFB'),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(6),
                  ),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Column(
                  children: reportStats.compliance.map((c) {
                    final colorHex = c.percentage >= 90
                        ? '#22C55E'
                        : (c.percentage >= 70 ? '#F59E0B' : '#EF4444');
                    final displaySensorName = c.sensorType == "HC-SR04"
                        ? "Nivel (HC-SR04)"
                        : (c.sensorType == "PH-4502C"
                              ? "pH (PH-4502C)"
                              : "Turbidez (TS300B)");
                    return pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Row(
                        children: [
                          pw.SizedBox(
                            width: 120,
                            child: pw.Text(
                              displaySensorName,
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Container(
                              height: 12,
                              decoration: const pw.BoxDecoration(
                                color: PdfColors.grey200,
                                borderRadius: pw.BorderRadius.all(
                                  pw.Radius.circular(6),
                                ),
                              ),
                              child: pw.Row(
                                children: [
                                  if (c.percentage > 0)
                                    pw.Expanded(
                                      flex: (c.percentage * 10).round().clamp(
                                        1,
                                        1000,
                                      ),
                                      child: pw.Container(
                                        height: 12,
                                        decoration: pw.BoxDecoration(
                                          color: PdfColor.fromHex(colorHex),
                                          borderRadius:
                                              const pw.BorderRadius.all(
                                                pw.Radius.circular(6),
                                              ),
                                        ),
                                      ),
                                    ),
                                  if (100 - c.percentage > 0)
                                    pw.Expanded(
                                      flex: ((100 - c.percentage) * 10)
                                          .round()
                                          .clamp(0, 1000),
                                      child: pw.SizedBox(),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.SizedBox(
                            width: 45,
                            child: pw.Text(
                              '${c.percentage}%',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex(colorHex),
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            // Eventos Críticos y Alertas
            if (dataPdf["includeCriticalEvents"] == true &&
                reportStats != null) ...[
              pw.SizedBox(height: 16),
              pw.Text(
                'Registro de Eventos Críticos y Alertas',
                style: pw.TextStyle(
                  color: PdfColor.fromHex('#4A90E2'),
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),

              // KPI Cards de Alertas por Sensor
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _buildAlertKpiCard(
                    'Total Alertas',
                    '${reportStats.alerts.totalAlerts}',
                    '#1E293B',
                  ),
                  _buildAlertKpiCard(
                    'Alertas Nivel',
                    '${reportStats.alerts.countByType["Nivel"] ?? 0}',
                    '#0284C7',
                  ),
                  _buildAlertKpiCard(
                    'Alertas pH',
                    '${reportStats.alerts.countByType["pH"] ?? 0}',
                    '#9333EA',
                  ),
                  _buildAlertKpiCard(
                    'Alertas Turbidez',
                    '${reportStats.alerts.countByType["Turbidez"] ?? 0}',
                    '#0D9488',
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Tabla de Alertas
              if (reportStats.alerts.alerts.isEmpty)
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  alignment: pw.Alignment.center,
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F9FAFB'),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(4),
                    ),
                  ),
                  child: pw.Text(
                    'No se registraron eventos críticos en este período.',
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey600,
                    ),
                  ),
                )
              else
                pw.TableHelper.fromTextArray(
                  border: pw.TableBorder.all(
                    color: PdfColors.grey300,
                    width: 0.5,
                  ),
                  headerStyle: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  headerDecoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#4A90E2'),
                  ),
                  cellStyle: const pw.TextStyle(fontSize: 7),
                  cellHeight: 18,
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.center,
                    2: pw.Alignment.centerLeft,
                    3: pw.Alignment.centerRight,
                  },
                  headers: [
                    'Fecha / Hora',
                    'Sensor',
                    'Descripción',
                    'Valor registrado',
                  ],
                  data: reportStats.alerts.alerts
                      .take(dataPdf["limitCriticalEvents"])
                      .map((alert) {
                        final dateStr = DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(alert.date);
                        return [
                          dateStr,
                          alert.type,
                          alert.description,
                          alert.triggerValue != null
                              ? (alert.triggerValue!.toCleanString().endsWith(
                                      '.0',
                                    )
                                    ? alert.triggerValue!.toInt().toString()
                                    : alert.triggerValue!.toCleanString())
                              : 'N/A',
                        ];
                      })
                      .toList(),
                ),
            ],
          ];
        },
      ),
    );

    return pdf.save();
  }
}
