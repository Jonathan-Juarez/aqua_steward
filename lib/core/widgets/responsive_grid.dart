import 'package:aqua_steward/core/theme/app_breakpoint.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/skeleton_format.dart';
import 'package:flutter/material.dart';

// Distribuye elementos en una cuadrícula responsiva según el tamaño de la pantalla.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> items;
  final bool isLoading;
  final Widget? skeletonItem;
  final int? skeletonCount;

  const ResponsiveGrid({
    super.key,
    required this.items,
    this.isLoading = false,
    this.skeletonItem,
    this.skeletonCount,
  });

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = AppBreakpoint.isDesktop(context)
        ? 3
        : (AppBreakpoint.isTablet(context) ? 2 : 1);

    if (isLoading && skeletonItem != null) {
      final count = skeletonCount ?? (AppBreakpoint.isDesktop(context) ? 3 : 2);
      return SkeletonFormat(
        isLoading: true,
        child: _buildLayout(
          crossAxisCount: crossAxisCount,
          elements: List.generate(count, (_) => skeletonItem!),
        ),
      );
    }

    return _buildLayout(
      crossAxisCount: crossAxisCount,
      elements: items,
    );
  }

  Widget _buildLayout({
    required int crossAxisCount,
    required List<Widget> elements,
  }) {
    if (crossAxisCount == 1) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: elements.length,
        separatorBuilder: (_, _) => AppSizedBox.height12,
        itemBuilder: (_, index) => elements[index],
      );
    }

    final List<List<Widget>> rows = [];
    for (int i = 0; i < elements.length; i += crossAxisCount) {
      rows.add(
        elements.sublist(
          i,
          (i + crossAxisCount > elements.length)
              ? elements.length
              : i + crossAxisCount,
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < rows.length; i++) ...[
          if (i > 0) AppSizedBox.height12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int j = 0; j < rows[i].length; j++) ...[
                if (j > 0) AppSizedBox.width16,
                Expanded(child: rows[i][j]),
              ],
              for (int k = 0; k < crossAxisCount - rows[i].length; k++) ...[
                AppSizedBox.width16,
                const Expanded(child: SizedBox.shrink()),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
