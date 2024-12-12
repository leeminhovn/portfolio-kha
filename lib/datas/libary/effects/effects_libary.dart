
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_kha/constanst/app_images.dart';
import 'package:portfolio_kha/datas/libary/effects/effects_libary_store.dart';

class EffectsLibary {

  static Component sakeEffect(PositionComponent component, ) {
    return  SakeEffect(componentEffectTo: component);
  }

  static Component floatingEffect(PositionComponent component) {
    return FloatingEffect(componentEffectTo: component);
  }
  static Component boxBorderLightingStyle1(PositionComponent component) {
    return BoxBorderLightComponent(
            componentEffectTo: component, 
            items: [
              SpriteComponent.fromImage(Flame.images.fromCache(AppImages.logo_image, ), size:  component.size)
            ], 
            size: component.size, 
            speed: 2, 
            borderWidth: 7,
            colorsLinnear: [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.blue,
              Colors.indigo,
              Colors.purple,
            ], sizeEffect: Vector2(component.size.x*1.5, component.size.x*0.4) 
          );
  }

  static List<Component Function(PositionComponent component)> allEffects() => [sakeEffect, 
  boxBorderLightingStyle1,
  floatingEffect,
  ];
}
