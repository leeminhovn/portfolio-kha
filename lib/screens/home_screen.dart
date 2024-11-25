import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:portfolio_kha/component/flame_interface_widgets/column_component.dart';
import 'package:portfolio_kha/component/flame_interface_widgets/scroll_component.dart';
import 'package:portfolio_kha/component/flame_interface_widgets/wrap_component.dart';
import 'package:portfolio_kha/utils/color_helper.dart';

class HomeScreen extends PositionComponent with HasGameReference {
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    size = game.size;
    // add(ScrollComponent(size: Vector2(300, 300), items: [
    //   WrapComponent(
    //       alignment: WrapAlignment.spaceEvenly,
    //       runSpacing: 10,
    //       spacing: 60,
    //       size: size,
    //       children: [
    //         ...List.generate(
    //             100,
    //             (a) => RectangleComponent.square(
    //                   size: 20,
    //                 )..setColor(ColorHelper.randomBrightColor())).toList()
    //       ])
    // ]));
    add(ColumnComponent(children: [
      ...List.generate(
          100,
          (a) => RectangleComponent.square(
                size: 20,
              )..setColor(ColorHelper.randomBrightColor())).toList()
    ]));
    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }
}
