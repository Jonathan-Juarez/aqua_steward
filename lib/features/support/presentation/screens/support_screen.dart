import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/features/support/presentation/widgets/faq_item.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: "Soporte",
      children: [
        Padding(
          padding: AppPadding.symmetric16_0,
          child: Text(
            "Preguntas Frecuentes",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const FAQItem(
          question: "1. ¿Qué significa la turbidez del agua?",
          answer:
              "La turbidez indica la cantidad de partículas presentes en el agua. Un valor alto puede afectar la calidad.",
        ),
        const FAQItem(
          question: "2. ¿Qué significa el pH del agua?",
          answer:
              "El pH indica la acidez o alcalinidad del agua. Un valor alto puede afectar la calidad.",
        ),
        const FAQItem(
          question: "3. ¿Por qué recibo notificaciones de nivel de agua?",
          answer:
              "Se envían alertas cuando el nivel se acerca al límite establecido en la configuración.",
        ),
        const FAQItem(
          question: "4. ¿Cómo ajusto los límites y umbrales?",
          answer:
              "Ve a la sección Ajustes, mueve los controles deslizantes y guarda los cambios.",
        ),
        const FAQItem(
          question: "5. ¿Qué hago si no recibo notificaciones?",
          answer:
              "Verifica tu conexión y que las notificaciones estén activadas tanto en la app como en el sistema operativo.",
        ),
        const FAQItem(
          question: "6. ¿Con qué frecuencia se actualizan las lecturas?",
          answer:
              "Los sensores envían datos en tiempo real, con un tiempo de actualización de 3 segundos.",
        ),

        AppSizedBox.height16,

        // Tarjeta de Contacto
        ContainerFormat(
          children: [
            const Icon(Icons.contact_support, color: Colors.white70, size: 40),
            AppSizedBox.height16,
            Text(
              "¿Necesitas más ayuda?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              "Nuestro equipo técnico está disponible para asistirte.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AppSizedBox.height16,
            ButtonMain(
              label: "Contacto técnico",
              onPressed: () => Navigator.pushNamed(context, AppRouter.contact),
            ),
          ],
        ),
        AppSizedBox.height16,
      ],
    );
  }
}
