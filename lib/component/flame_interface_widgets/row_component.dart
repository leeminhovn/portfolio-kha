import 'package:flame/components.dart';

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

class RowComponent extends PositionComponent {
  RowComponent({
    super.position,
    super.size,
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
    _arrangeChildren();
  }

  void _arrangeChildren() {
    if (children.isEmpty) return;

    final components = children.whereType<PositionComponent>().toList();
    double totalWidth = components.fold(0.0, (sum, child) => sum + child.width);
    double totalSpacing = spacing * (components.length - 1);
    
    double startX = 0;
    double spacingBetween = spacing;

    // Handle main axis alignment (horizontal)
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
        // Default behavior
    }

    double currentX = startX;
    for (final child in components) {
      // Handle cross axis alignment (vertical)
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