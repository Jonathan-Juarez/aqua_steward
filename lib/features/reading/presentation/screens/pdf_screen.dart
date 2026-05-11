import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

  // Genera el PDF con la configuración seleccionada. Uint8List es un tipo de dato que representa una lista de bytes, que es lo que necesita la librería pdf.
  Future<Uint8List> _generatePdf(Map<String, dynamic> dataPdf) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                dataPdf["filename"],
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (dataPdf["dateRange"] != null) ...[
                pw.SizedBox(height: 10),
                pw.Text(
                  'Período: ${dataPdf["dateRange"].start.day}/${dataPdf["dateRange"].start.month}/${dataPdf["dateRange"].start.year} - ${dataPdf["dateRange"].end.day}/${dataPdf["dateRange"].end.month}/${dataPdf["dateRange"].end.year}',
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
              pw.SizedBox(height: 20),
              pw.Text(
                'Configuración seleccionada:',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 10),
              pw.Bullet(text: 'Estadísticas: ${dataPdf["includeStats"]}'),
              pw.Bullet(text: 'Cumplimiento: ${dataPdf["includeCompliance"]}'),
              pw.Bullet(text: 'Estabilidad: ${dataPdf["includeStability"]}'),
              pw.Bullet(text: 'Alertas: ${dataPdf["includeAlerts"]}'),
              pw.Bullet(
                text: 'Eventos Críticos: ${dataPdf["includeCriticalEvents"]}',
              ),
              if (dataPdf["chartImage"] != null) ...[
                pw.SizedBox(height: 16),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(dataPdf["chartImage"]),
                    width: 500,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
