import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:portfolio_kha/component/commons/component_effect_base.dart';
import 'package:portfolio_kha/component/commons/radius_box.dart';

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
class BoxBorderLightComponent extends PositionComponent {
  final List<Component> items;
  final PositionComponent componentEffectTo;
  final List<Color> colorsLinnear ;
  final Color colorBackground;
  final double speed;
  final Vector2 sizeEffect;
  final double radius;
  final double borderWidth;
  BoxBorderLightComponent( {
    required this.componentEffectTo, 
    required this.items,
    this.colorBackground = Colors.black,
    this.radius = 10,
    required this.colorsLinnear,
    required this.speed,
    required this.sizeEffect,
    required this.borderWidth,
    super.size
  });
  @override
  FutureOr<void> onLoad() {
    add(
        _ConicGradientComponent( 
          colors: colorsLinnear,
          rotationSpeed: speed,
          position: size/2,
          radius: radius,
          sizeEffect:sizeEffect,
          borderWidth: borderWidth,
          size: size
        )
      );
    add(ClipComponent(
      children: items,
      builder: (a) {
    
    return RoundedRectangle.fromRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, width, height), Radius.circular(radius)));
    }));
   

    return super.onLoad();
  }
  
}


class _ConicGradientComponent extends PositionComponent {
  final List<Color> colors;
  late final Rect _rect;
  late final RRect _rectClip;

  late final Paint _shadowPaint;
  final double inflate = 0;
  final double radius;
  final Vector2 sizeEffect;
  double rotationSpeed = 1;
  final double borderWidth;
 late double _angle = angle;

  @override
  void update(double dt) {
    _angle += rotationSpeed * dt; 
    _angle %= 2 * pi; 
    super.update(dt);
  }
  _ConicGradientComponent({
    required this.colors,
    required Vector2 position,
    required this.radius,
    this.borderWidth = 5,
    required this.rotationSpeed,
    required Vector2 size,
    required this.sizeEffect,
  }) : super(position: position, size: size);
  @override
  FutureOr<void> onLoad() {
    final double maxSize = max(sizeEffect.x,sizeEffect.y);
    final double minSize = min(sizeEffect.x, sizeEffect.y);
    anchor= Anchor.center;
    _rect = Rect.fromLTWH(-maxSize/2, -minSize/2, maxSize , minSize);
    _rectClip = RRect.fromRectAndRadius(
      Rect.fromLTWH(-width/2 -borderWidth/2, -height/2 -borderWidth/2, size.x+ borderWidth, size.y+borderWidth),
      Radius.circular(radius)
    );

      _shadowPaint = Paint()
        // ..maskFilter =  MaskFilter.blur(BlurStyle.normal, blur)
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        )
      .createShader(_rect.inflate(inflate));
    
    return super.onLoad();
  }
 
  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(width / 2, height / 2);
    canvas.clipRRect(_rectClip);

    canvas.rotate(_angle);
    canvas.drawRect(_rect, _shadowPaint);
    canvas.restore();
  }
}



class MoneyChangeStyle1 extends PositionComponent {
  int _currentMoney;
  int _targetMoney;
  double _changeRate = 0; 
  final TextPaint textPaint;
  late final TextComponent textComponent;

  MoneyChangeStyle1({
    required int initialMoney,
    required this.textPaint,
    super.position,
    super.anchor,
    super.size,
  }) : _currentMoney = initialMoney,
       _targetMoney = initialMoney;
  @override
  FutureOr<void> onLoad() {
    textComponent = TextComponent(text:'$_currentMoney', textRenderer: textPaint);
    add(textComponent);
    return super.onLoad();
  }
  void changeMoney(int newMoney, double duration) {
    if(isMounted) {
     _targetMoney = newMoney;
    _changeRate = (_targetMoney - _currentMoney) / duration;
    } else {
    _targetMoney = newMoney;
    _currentMoney = newMoney;
    }
   
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_currentMoney != _targetMoney) {
      final change = (_changeRate * dt).round();
      _currentMoney += change;

      // Đảm bảo không vượt qua giá trị đích
      if ((_changeRate > 0 && _currentMoney > _targetMoney) ||
          (_changeRate < 0 && _currentMoney < _targetMoney)) {
        _currentMoney = _targetMoney;
      }
    }
    textComponent.text = '$_currentMoney';
    size = textComponent.size;
  }
}


class BouncingScaleEffectOnce extends PositionComponent {
  final PositionComponent componentEffectTo;
  BouncingScaleEffectOnce({
    required this.componentEffectTo,
    required double scaleFrom  ,
    double duration = 1,
    bool isLoop = false,
    void Function()? onComplete,
    super.size,
  }) {

    final Anchor anchorOld = componentEffectTo.anchor;
    final Vector2 vectorIncreadToCenter = componentEffectTo.positionOfAnchor(Anchor.center) - componentEffectTo.position;
    componentEffectTo.anchor = Anchor.center;
    componentEffectTo.position += vectorIncreadToCenter;
    componentEffectTo.scale = Vector2.all(scaleFrom);

    componentEffectTo.add(
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: duration ,  curve: Curves.bounceOut, infinite: isLoop),
        onComplete: () {
          componentEffectTo.anchor = anchorOld;
          componentEffectTo.position -= vectorIncreadToCenter;
          onComplete?.call();
          }, // Xoá sau khi hoàn tất
      ),
    );
  }
}

class SlotMachineReel extends PositionComponent {
  // idItemsGet it is id of items get when slot machine reel stop
  final List<String> idItemsGet;
  // itemsWheel it is items in slot machine reel
  final List<ItemSlotMachineReel> itemsWheel;
  final int column;
  void Function() onStartWheel;
  void Function() onCompleteWheel;
  final Vector2 sizeItem;

  startWheel() {
    onStartWheel();
  }

  SlotMachineReel({
    required this.idItemsGet,
    required this.itemsWheel,
    required this.column,
    required this.onStartWheel,
    required this.onCompleteWheel,
    required this.sizeItem,
    super.size
  });

  @override
  FutureOr<void> onLoad() {
    width = sizeItem.x * column;
    height = sizeItem.y;
    debugColor = Colors.red;
    debugMode = true;
    return super.onLoad();
  }
}

class ItemSlotMachineReel extends PositionComponent {
  final String idItem;
  ItemSlotMachineReel({required this.idItem, super.children});
  @override
  FutureOr<void> onLoad() {
    ;
    return super.onLoad();
  }
}