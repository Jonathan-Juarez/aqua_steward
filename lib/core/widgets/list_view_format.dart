import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/skeleton_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class ListViewFormat extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final String? emptyMessage;
  final Widget? emptyWidget;
  final Widget? skeletonItem;
  final int skeletonCount;

  const ListViewFormat({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.isLoading = false,
    this.emptyMessage,
    this.emptyWidget,
    this.skeletonItem,
    this.skeletonCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Se muestra el skeleton placeholder si la petición está activa y la lista está vacía.
    if (isLoading && itemCount == 0) {
      return SkeletonFormat(
        isLoading: true,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: padding ?? EdgeInsets.zero,
          itemCount: skeletonCount,
          separatorBuilder: (_, _) => AppSizedBox.height12,
          itemBuilder: (context, index) =>
              skeletonItem ?? _defaultSkeleton(context),
        ),
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

  Widget _defaultSkeleton(BuildContext context) {
    return const ContainerListTile(
      title: "Título de prueba",
      subtitle: "Descripción o subtítulo de prueba",
      icon: Icon(Icons.circle),
      showTrailing: false,
    );
  }
}
