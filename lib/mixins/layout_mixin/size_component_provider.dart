import 'dart:async';

import 'package:flame/components.dart';

mixin SizeComponentProvider on PositionComponent {
 @override
  void onMount() {
    double maxWidth = 0;
    double maxHeight = 0;
    children.whereType<PositionComponent>().forEach((a) {
      final double checkHeight = a.positionOfAnchor(Anchor.bottomCenter).y;
      if (checkHeight > maxHeight) {
        maxHeight = checkHeight;
      }
      final double checkWidth = a.positionOfAnchor(Anchor.topRight).x;

      if (checkWidth > maxWidth) {
        maxWidth = checkWidth;
      }
    });
    size = Vector2(maxWidth, maxHeight);
    super.onMount();
  }
}
