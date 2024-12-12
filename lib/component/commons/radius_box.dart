import 'dart:ui';

import 'package:flame/components.dart';

class RadiusBox extends PositionComponent {
   double borderRadius;
   Paint paint;
   RRect? rrectCustom;
  RadiusBox({required Vector2 size, required this.borderRadius, required this.paint, this.rrectCustom}) {
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = rrectCustom ?? RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, paint);
  }
}
