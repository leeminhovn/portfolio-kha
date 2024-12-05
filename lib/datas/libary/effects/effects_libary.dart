import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class EffectsLibary {
  static SequenceEffect sakeEffect (PositionComponent component) => SequenceEffect(
      [
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
          EffectController(duration: 0.1),
        ),
      ],
      infinite: true, 
    );
}