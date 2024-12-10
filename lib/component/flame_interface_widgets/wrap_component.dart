import 'dart:async';

import 'package:flame/components.dart';
import 'package:portfolio_kha/mixins/layout_mixin/size_component_provider.dart';

enum WrapAlignment {
  start,
  center,
  spaceAround,
  spaceBetween,
  spaceEvenly,
}

class WrapComponent extends PositionComponent with SizeComponentProvider {
  @override
  bool get debugMode => true;
  late final PositionComponent _parentUp;
  WrapComponent({
    super.position,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    this.spacing = 0,
    this.runSpacing = 0,
    this.alignment = WrapAlignment.start,
  });

  final double spacing;

  final double runSpacing;
  final WrapAlignment alignment;
  @override
  void onMount() {

    super.onMount();
  }

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    _parentUp = parent as PositionComponent;
    _arrangeChildren();

    return super.onLoad();
  }

  void _arrangeChildren() {
    if (children.isEmpty) return;

    final rows = <List<PositionComponent>>[];
    List<PositionComponent> currentRow = [];
    double currentX = 0;
    double rowHeight = 0;

    for (final child in children) {
      if (child is PositionComponent) {
        if (currentX + child.width > _parentUp.width) {
          if (currentRow.isNotEmpty) {
            rows.add(currentRow);
            currentRow = [];
          }
          currentX = 0;
        }
        currentRow.add(child);
        currentX += child.width + spacing;
        rowHeight = rowHeight < child.height ? child.height : rowHeight;
      }
    }
    if (currentRow.isNotEmpty) {
      rows.add(currentRow);
    }

    double currentY = 0;
    for (final row in rows) {
      double rowWidth = row.fold(0.0, (sum, child) => sum + child.width);
      rowWidth += spacing * (row.length - 1);

      double startX = 0;
      double spacingBetween = spacing;

      switch (alignment) {
        case WrapAlignment.center:
          startX = (width - rowWidth) / 2;
          break;
        case WrapAlignment.spaceAround:
          spacingBetween = (width - rowWidth + (spacing * (row.length - 1))) / (row.length + 1);
          startX = spacingBetween;
          break;

        case WrapAlignment.spaceBetween:
          spacingBetween = row.length > 1 ? (width - rowWidth + (spacing * (row.length - 1))) / (row.length - 1) : 0;
          break;
       
        case WrapAlignment.spaceEvenly:
          spacingBetween = (width - rowWidth + (spacing * (row.length - 1))) / (row.length + 1);
          startX = spacingBetween;
          break;

        case WrapAlignment.start:
        // Default behavior, no changes needed
      }

      double x = startX;
      rowHeight = row.fold(0.0, (maxHeight, child) => maxHeight < child.height ? child.height : maxHeight);

      for (final child in row) {
        child.position = Vector2(x, currentY);
        x += child.width + spacingBetween;
      }

      currentY += rowHeight + runSpacing;
    }
  }
}
