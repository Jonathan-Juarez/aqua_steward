import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class ListViewFormat extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final String? emptyMessage;
  final Widget? emptyWidget;

  const ListViewFormat({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.isLoading = false,
    this.emptyMessage,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Se muestra indicador de carga si la petición está activa y la lista está vacía.
    if (isLoading && itemCount == 0) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Se muestra el estado vacío si no hay elementos.
    if (itemCount == 0 && (emptyMessage != null || emptyWidget != null)) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emptyWidget != null) ...[emptyWidget!, AppSizedBox.height12],
              if (emptyMessage != null)
                TextFormat(
                  text: emptyMessage!,
                  type: "bodySecondary",
                  context: context,
                ),
            ],
          ),
        ),
      );
    }

    // Se renderiza la lista con separadores.
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.zero,
      itemCount: itemCount,
      separatorBuilder: (_, _) => AppSizedBox.height12,
      itemBuilder: itemBuilder,
    );
  }
}
