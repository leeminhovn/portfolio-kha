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

class RowComponent extends PositionComponent with SizeComponentProvider{
  RowComponent({
    super.position,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    this.spacing = 0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  void onMount() {
    super.onMount();
  }
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    _arrangeChildren();
    
    return super.onLoad();
  }
  void _arrangeChildren() {
    if (children.isEmpty) return;

    final components = children.whereType<PositionComponent>().toList();
    double totalWidth = components.fold(0.0, (sum, child) => sum + child.width);
    double totalSpacing = spacing * (components.length - 1);
    
    double startX = 0;
    double spacingBetween = spacing;

    switch (mainAxisAlignment) {
      case MainAxisAlignment.center:
        startX = (width - (totalWidth + totalSpacing)) / 2;
      case MainAxisAlignment.end:
        startX = width - (totalWidth + totalSpacing);
      case MainAxisAlignment.spaceBetween:
        spacingBetween = components.length > 1 ? 
          (width - totalWidth) / (components.length - 1) : 0;
      case MainAxisAlignment.spaceAround:
        spacingBetween = (width - totalWidth) / (components.length + 1);
        startX = spacingBetween;
      case MainAxisAlignment.spaceEvenly:
        spacingBetween = (width - totalWidth) / (components.length + 1);
        startX = spacingBetween;
      case MainAxisAlignment.start:
    }

    double currentX = startX;
    for (final child in components) {
      double y = 0;
      switch (crossAxisAlignment) {
        case CrossAxisAlignment.center:
          y = (height - child.height) / 2;
        case CrossAxisAlignment.end:
          y = height - child.height;
        case CrossAxisAlignment.start:
          y = 0;
      }
      
      child.position = Vector2(currentX, y);
      currentX += child.width + spacingBetween;
    }
  }
}