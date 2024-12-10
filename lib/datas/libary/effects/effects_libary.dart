
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:portfolio_kha/datas/libary/effects/effects_libary_store.dart';

class EffectsLibary {

  static Component sakeEffect(PositionComponent component, ) {
   
    return  SakeEffect(componentEffectTo: component);
  }

   static Component floatingEffect(PositionComponent component) {
    
    return FloatingEffect(componentEffectTo: component);
  }

  static List<Component Function(PositionComponent component)> allEffects() => [sakeEffect,floatingEffect];
}
