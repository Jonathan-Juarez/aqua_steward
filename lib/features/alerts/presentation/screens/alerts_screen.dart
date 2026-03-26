import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/button_dynamic.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  // Estado de los filtros (Solo Tipo)
  String _selectedType = 'Todos'; // Todos, Nivel, Turbidez, pH

  // Datos simulados
  final List<Map<String, dynamic>> _notifications = [
    {
      "id": 1,
      "title": "Nivel",
      "message": "El depósito está al 75% de su capacidad. ",
      "type": "Nivel",
      "icon": AppIcon.waterDrop,
      "date": DateTime.now(),
    },
    {
      "id": 2,
      "title": "Turbidez",
      "message": "Se ha superado el límite, actual 5 NTU.",
      "type": "Turbidez",
      "icon": AppIcon.water,
      "date": DateTime.now(),
    },
    {
      "id": 3,
      "title": "pH",
      "message": "El pH actual es 6.5, dentro del rango ideal.",
      "type": "pH",
      "icon": AppIcon.scienceRounded,
      "date": DateTime.now(),
    },
    {
      "id": 4,
      "title": "pH",
      "message": "Nivel de pH bajo (5.5). Requiere revisión.",
      "type": "pH",
      "icon": AppIcon.scienceRounded,
      "date": DateTime.now(),
    },
  ];

  // Lógica para filtrar la lista (Solo por Tipo)
  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedType == 'Todos') {
      return _notifications;
    }
    return _notifications
        .where((notif) => notif['type'] == _selectedType)
        .toList();
  }

  void _deleteAll() {
    setState(() {
      _notifications.clear();
    });
    SnackBarFormat.show(context, "Se eliminaron todas las notificaciones");
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: "Alertas",
      children: [
        AppSizedBox.height16,
        // Filtros por tipo de sensor.
        Row(
          children: [
            FilterChipFormat(
              label: "Todos",
              isSelected: _selectedType == "Todos",
              onSelected: (val) => setState(() => _selectedType = "Todos"),
            ),
            FilterChipFormat(
              label: "Nivel",
              isSelected: _selectedType == "Nivel",
              onSelected: (val) => setState(() => _selectedType = "Nivel"),
            ),
            FilterChipFormat(
              label: "pH",
              isSelected: _selectedType == "pH",
              onSelected: (val) => setState(() => _selectedType = "pH"),
            ),
            FilterChipFormat(
              label: "Turbidez",
              isSelected: _selectedType == "Turbidez",
              onSelected: (val) => setState(() => _selectedType = "Turbidez"),
            ),
            const Spacer(),

            // Botón para eliminar todas las notificaciones.
            ButtonDynamic(
              onPressed: _filteredNotifications.isNotEmpty ? _deleteAll : null,
              icon: _filteredNotifications.isNotEmpty
                  ? AppIcon.deleteSweep()
                  : AppIcon.deleteSweep(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
            ),
          ],
        ),

        AppSizedBox.height16,

        // Lista de Notificaciones
        _filteredNotifications.isEmpty
            ? Center(
                heightFactor: 5,
                child: Column(
                  children: [
                    AppIcon.notificationsOffOutlined(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    AppSizedBox.height24,
                    Text(
                      "Sin notificaciones",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredNotifications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final notif = _filteredNotifications[index];
                  return Dismissible(
                    key: Key(notif['id'].toString()),
                    onDismissed: (direction) {
                      setState(() {
                        _notifications.removeWhere(
                          (item) => item['id'] == notif['id'],
                        );
                      });
                    },
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: AppBorder.all8,
                        color: AppColor.error.withOpacity(0.2),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: AppIcon.deleteOutline,
                    ),
                    child: containerNotification(
                      notif['title'],
                      notif['message'],
                      notif['date'],
                      notif['icon'],
                    ),
                  );
                },
              ),
      ],
    );
  }

  ContainerFormat containerNotification(
    String title,
    String message,
    DateTime date,
    Icon icon,
  ) => ContainerFormat(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono contextual
          Container(
            padding: AppPadding.all8,
            decoration: BoxDecoration(
              color: icon.color?.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: icon,
          ),
          AppSizedBox.width8,

          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  date.toString(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
