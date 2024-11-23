import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:portfolio_kha/component/flame_interface_widgets/wrap_component.dart';
import 'package:portfolio_kha/utils/color_helper.dart';

class HomeScreen extends PositionComponent {
  @override
  // TODO: implement debugMode
  bool get debugMode => true;
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    size = Vector2(200, 200);

    add(WrapComponent(
      alignment :WrapAlignment.spaceEvenly,
      runSpacing: 10,
      spacing: 60,
      size:  size,
      children: [
      RectangleComponent.square(
        size: 20,
      )..setColor(ColorHelper.randomBrightColor()),
      RectangleComponent.square(
        size: 20,
      )..setColor(ColorHelper.randomBrightColor()),
      RectangleComponent.square(
        size: 20,
      )..setColor(ColorHelper.randomBrightColor()),
      RectangleComponent.square(
        size: 20,
      )..setColor(ColorHelper.randomBrightColor()),
      RectangleComponent.square(
        size: 20,
      )..setColor(ColorHelper.randomBrightColor()),
      RectangleComponent.square(
        size: 20,
      )..setColor(ColorHelper.randomBrightColor()),
      RectangleComponent.square(
        size: 20,
      )..setColor(ColorHelper.randomBrightColor()),
    ]));
    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }
}
