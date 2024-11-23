import 'package:flame/components.dart';

class ColumnComponent extends PositionComponent {
  ColumnComponent({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    this.spacing = 0,
  });

  /// Space between components vertically
  final double spacing;

  @override
  void onMount() {
    super.onMount();
    _arrangeChildren();
  }

  void _arrangeChildren() {
    if (children.isEmpty) return;

    double currentY = 0;

    for (final child in children) {
      if (child is PositionComponent) {
        child.position = Vector2(0, currentY);
        currentY += child.height + spacing;
      }
    }
  }
} 