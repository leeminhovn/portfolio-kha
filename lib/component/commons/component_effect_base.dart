import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class ComponentEffectBase extends Component {
  late final Effect effect;
  final PositionComponent componentEffectTo;
  ComponentEffectBase({required this.componentEffectTo, });
}