import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_interactive.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  final String titleParameter;
  const ReportsScreen({super.key, required this.titleParameter});

  @override
  Widget build(BuildContext context) {
    // Generamos nombres de reportes basados en el título para que parezca dinámico
    final String title = titleParameter.split(
      ' ',
    )[0]; // "Nivel", "Turbidez", etc.
    final List<Map<String, String>> reportes = [
      {
        "fecha": "9 Dic 2025",
        "size": "1.4 MB",
        "name": "Reporte_${title}_4.pdf",
      },
      {
        "fecha": "2 Dic 2025",
        "size": "1.2 MB",
        "name": "Reporte_${title}_3.pdf",
      },
      {
        "fecha": "25 Nov 2025",
        "size": "0.9 MB",
        "name": "Reporte_${title}_2.pdf",
      },
      {
        "fecha": "18 Nov 2025",
        "size": "1.0 MB",
        "name": "Reporte_${title}_1.pdf",
      },
    ];

    return Column(
      children: [
        ContainerInteractive(
          onTap: () => Navigator.pushNamed(context, AppRouter.generateReports),
          title: "Generar reporte",
          icon: AppIcon.addChart,
        ),

        AppSizedBox.height16,

        // Historial
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Historial",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        AppSizedBox.height16,

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reportes.length,
          separatorBuilder: (c, i) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return ContainerFormat(
              children: [
                ListTile(
                  leading: AppIcon.pdf,
                  title: Text(
                    reportes[index]["name"]!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    "${reportes[index]["fecha"]} • ${reportes[index]["size"]}",
                    style: AppText.smallSecondary,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
