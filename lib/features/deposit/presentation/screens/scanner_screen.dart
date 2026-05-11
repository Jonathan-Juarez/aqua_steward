import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_qr,
      children: [
        Padding(
          padding: AppPadding.all16,
          child: ContainerFormat(
            children: [
              ClipRRect(
                borderRadius: AppBorder.all8,
                // Hace que la cámara sea cuadrada.
                child: AspectRatio(
                  aspectRatio: 1,
                  child: MobileScanner(
                    controller: cameraController,
                    onDetect: (BarcodeCapture capture) {
                      if (_isScanned) return;

                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          setState(() {
                            _isScanned = true;
                          });
                          final String code = barcode.rawValue!;

                          // Detiene el hardware de la cámara explícitamente para evitar fugas de memoria o logs innecesarios
                          cameraController.stop();

                          // Cierra la pantalla y devuelve el texto
                          Navigator.pop(context, code);
                          break;
                        }
                      }
                    },
                  ),
                ),
              ),
              AppSizedBox.height12,
              TextFormat(
                context: context,
                text:
                    "Apunta tu cámara al código QR para obtener la IP del kit.",
                type: "body",
                alignCenter: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
