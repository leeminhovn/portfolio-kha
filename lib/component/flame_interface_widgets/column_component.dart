import 'dart:async';

import 'package:flame/components.dart';
import 'package:portfolio_kha/mixins/layout_mixin/size_component_provider.dart';

enum MainAxisAlignment {
  start,
  center,
  end,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

enum CrossAxisAlignment {
  start,
  center,
  end,
}

class ColumnComponent extends PositionComponent with SizeComponentProvider {
  ColumnComponent({
    super.position,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    this.spacing = 0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) {}
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    _arrangeChildren();
    super.onLoad();
  }

  @override
  // TODO: implement debugMode
  bool get debugMode => true;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  void _arrangeChildren() {
    if (children.isEmpty) return;

    final components = children.whereType<PositionComponent>().toList();
    double totalHeight =
        components.fold(0.0, (sum, child) => sum + child.height);
    double totalSpacing = spacing * (components.length - 1);

    double startY = 0;
    double spacingBetween = spacing;

    // Handle main axis alignment (vertical)
    switch (mainAxisAlignment) {
      case MainAxisAlignment.center:
        startY = (height - (totalHeight + totalSpacing)) / 2;
      case MainAxisAlignment.end:
        startY = height - (totalHeight + totalSpacing);
      case MainAxisAlignment.spaceBetween:
        spacingBetween = components.length > 1
            ? (height - totalHeight) / (components.length - 1)
            : 0;
      case MainAxisAlignment.spaceAround:
        spacingBetween = (height - totalHeight) / (components.length + 1);
        startY = spacingBetween;
      case MainAxisAlignment.spaceEvenly:
        spacingBetween = (height - totalHeight) / (components.length + 1);
        startY = spacingBetween;
      case MainAxisAlignment.start:
      // Default behavior
    }

    double currentY = startY;
    for (final child in components) {
      // Handle cross axis alignment (horizontal)
      double x = 0;
      switch (crossAxisAlignment) {
        case CrossAxisAlignment.center:
          x = (width - child.width) / 2;
        case CrossAxisAlignment.end:
          x = width - child.width;
        case CrossAxisAlignment.start:
          x = 0;
      }

      child.position = Vector2(x, currentY);
      currentY += child.height + spacingBetween;
    }
  }
}
