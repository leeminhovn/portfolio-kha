import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/layout.dart';
import 'package:portfolio_kha/component/flame_interface_widgets/column_component.dart';
import 'package:portfolio_kha/component/flame_interface_widgets/scroll_component.dart';
import 'package:portfolio_kha/component/flame_interface_widgets/wrap_component.dart';
import 'package:portfolio_kha/utils/color_helper.dart';

class HomeScreen extends PositionComponent with HasGameReference {
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    size = game.size;
    add(AlignComponent(
        alignment: Anchor.center,
        child: ScrollComponent(size: size, items: [
          WrapComponent(
              alignment: WrapAlignment.start,
              runSpacing: 10,
              spacing: 60,
              children: []
              )
        ]))
      ..debugMode = true);
    // add(ColumnComponent(children: [
    //   ...List.generate(
    //       100,
    //       (a) => RectangleComponent.square(
    //             size: 20,
    //           )..setColor(ColorHelper.randomBrightColor())).toList()
    // ]));
    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }
}
