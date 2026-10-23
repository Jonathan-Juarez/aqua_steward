import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/menu_button_format.dart';
import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';
import 'package:aqua_steward/features/reading/presentation/providers/reading_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogExportCsv {
  static void show({required BuildContext context, required Deposit deposit}) {
    // Tipos de sensores activos calculados por el dominio.
    final sensorTypes = deposit.activeSensorTypes;
    if (sensorTypes.isEmpty) {
      SnackBarFormat(
        context: context,
        message: context.l10n.snackbar_csv_sin_datos,
      ).show();
      return;
    }

    // Inicializar mapa de sensores seleccionados
    final Map<String, bool> selectedSensors = {
      for (final type in sensorTypes) type: true,
    };

    String tempFilter = "Dia";

    DialogEmergent(
      title: context.l10n.csv_dialogo_titulo,
      content: StatefulBuilder(
        builder: (dialogCtx, setStateDialog) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormat(
                  text: context.l10n.csv_seleccionar_sensores,
                  type: "bodySecondary",
                  context: context,
                ),
                ...sensorTypes.map((type) {
                  final String displayName = switch (type) {
                    "HC-SR04" => context.l10n.sensor_nivel,
                    "PH-4502C" => context.l10n.sensor_ph,
                    "TS300B" => context.l10n.sensor_turbidez,
                    _ => type,
                  };
                  //Checkbox individual para seleccionar cada sensor.
                  return CheckboxListTile(
                    title: TextFormat(
                      text: displayName,
                      type: "body",
                      context: context,
                    ),
                    value: selectedSensors[type] ?? false,
                    checkColor: AppColor.white,
                    activeColor: AppColor.success,
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedSensors[type] = val ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  );
                }),
                AppSizedBox.height12,
                MenuButtonFormat(
                  items: [
                    MenuItemModel(
                      text: context.l10n.csv_rango_dia,
                      value: "Dia",
                    ),
                    MenuItemModel(
                      text: context.l10n.csv_rango_semana,
                      value: "Semana",
                    ),
                    MenuItemModel(
                      text: context.l10n.csv_rango_mes,
                      value: "Mes",
                    ),
                  ],
                  onSelected: (value) {
                    setStateDialog(() {
                      tempFilter = value;
                    });
                  },
                  child: ContainerListTile(
                    title: context.l10n.csv_rango_temporal,
                    subtitle: switch (tempFilter) {
                      "Dia" => context.l10n.csv_rango_dia,
                      "Semana" => context.l10n.csv_rango_semana,
                      "Mes" => context.l10n.csv_rango_mes,
                      _ => tempFilter,
                    },
                    icon: AppIcon.calendarMonth(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    showTrailing: true,
                    trailing: AppIcon.arrowRight(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onPressed: () async {
        final chosenSensors = selectedSensors.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList();

        if (chosenSensors.isEmpty) {
          return;
        }

        Navigator.pop(context);
        SnackBarFormat(
          context: context,
          message: context.l10n.snackbar_csv_exportando,
        ).show();

        final result = await context.read<ReadingProvider>().exportReadings(
          depositId: deposit.id ?? "",
          sensorTypes: chosenSensors,
          depositName: deposit.name ?? "",
          filter: tempFilter,
        );

        if (!context.mounted) return;

        context.processResult(result);
      },
    ).show(context);
  }
}
