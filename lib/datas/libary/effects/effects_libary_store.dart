import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:portfolio_kha/component/commons/component_effect_base.dart';

class SakeEffect extends ComponentEffectBase {
  SakeEffect({required super.componentEffectTo, }) {

    final Anchor anchorOld = componentEffectTo.anchor;
    final Vector2 vectorIncreadToCenter = componentEffectTo.positionOfAnchor(Anchor.center) - componentEffectTo.position;
    componentEffectTo.anchor = Anchor.center;
    componentEffectTo.position += vectorIncreadToCenter;
    effect = SequenceEffect([
        RotateEffect.by(
          0.1, 
          EffectController(duration: 0.1), 
        ),
        RotateEffect.by(
          -0.2, 
          EffectController(duration: 0.2),
        ),
        RotateEffect.by(
          0.1, 
          EffectController(duration: 0.1,
          
          ),
        ),
        
    ], 
    infinite: true,
    onComplete: () {
      componentEffectTo.anchor = anchorOld;
      componentEffectTo.position -= vectorIncreadToCenter;
    });
    componentEffectTo.add(effect);
  }

}


class FloatingEffect extends ComponentEffectBase {
  FloatingEffect({required super.componentEffectTo, }) {

    effect = SequenceEffect(
      [
       MoveByEffect(
          Vector2(0, -10), // Di chuyển lên trên 10 pixel
          EffectController(duration: 0.5, reverseDuration: 0.5),
        ),
        MoveByEffect(
          Vector2(0, 10), // Di chuyển xuống dưới 10 pixel
          EffectController(duration: 0.5, reverseDuration: 0.5),
        ),
        
      ],
      infinite: true,
      onComplete: () {
        
      },
    );
    componentEffectTo.add(effect);
  }

}
class BoxBorderLightComponent extends ComponentEffectBase {
  BoxBorderLightComponent({required super.componentEffectTo});
  
}
