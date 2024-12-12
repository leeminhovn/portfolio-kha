
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_kha/constanst/app_images.dart';
import 'package:portfolio_kha/datas/libary/effects/effects_libary_store.dart';

class EffectsLibary {

  static Component sakeEffect(PositionComponent component, ) {
     component.add(
       SpriteComponent.fromImage(Flame.images.fromCache(AppImages.logo_image, ), size:  component.size)
    );
    return  SakeEffect(componentEffectTo: component);
  }

  static Component floatingEffect(PositionComponent component) {
    component.add(
       SpriteComponent.fromImage(Flame.images.fromCache(AppImages.logo_image, ), size:  component.size)
    );
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

  static Component moneyChangeStyle1(PositionComponent component) {
    TextPaint textPaint = TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24),);
    final MoneyChangeStyle1 compo = MoneyChangeStyle1(initialMoney: 500, textPaint: textPaint,)..debugMode = true;
    // Future.delayed(Duration(milliseconds: 500), () {
      compo.changeMoney(100, 5);
    // });
        Future.delayed(Duration(milliseconds: 500), () {
      compo.changeMoney(1000, 5);
    });
    return compo;
  }

  static List<Component Function(PositionComponent component)> allEffects() => [
    sakeEffect, 
    boxBorderLightingStyle1,
    moneyChangeStyle1,
    floatingEffect,
  ];
}


