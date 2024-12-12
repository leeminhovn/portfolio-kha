import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:portfolio_kha/component/flame_interface_widgets/scroll_component.dart';
import 'package:portfolio_kha/component/flame_interface_widgets/wrap_component.dart';
import 'package:portfolio_kha/constanst/app_images.dart';
import 'package:portfolio_kha/datas/libary/effects/effects_libary.dart';

class HomeScreen extends PositionComponent with HasGameReference {
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    size = game.size;
    final Vector2 sizeItem = Vector2.all(size.x / 3.53);
    final List<Component Function(PositionComponent component)> listEffects = EffectsLibary.allEffects();
    final Vector2 sizeScroll = Vector2(width*0.9, height*0.9);
    add(ScrollComponent(
        size: sizeScroll, 
        items: [
          WrapComponent(alignment: WrapAlignment.start, runSpacing: 10, spacing: ((sizeScroll.x - sizeItem.x * 3) / 2), children: [
            ...List.generate(listEffects.length, (index) {
              return ItemLibary(effect: listEffects[index], size: sizeItem);
            }),
            
          ])
        ],
        
    )..position= Vector2(width*0.05, height*0.05));

    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }
}

class ItemLibary extends SpriteComponent {
  final Component Function(PositionComponent component) effect;
  ItemLibary({super.size, required this.effect}) : super.fromImage(Flame.images.fromCache(AppImages.logo_image));
  @override
  void onMount() {
    // TODO: implement onMount

    add(effect(this));
    super.onMount();
  }
}
