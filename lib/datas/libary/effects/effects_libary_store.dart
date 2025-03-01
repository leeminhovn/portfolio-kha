import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/painting.dart';
import 'package:portfolio_kha/component/commons/component_effect_base.dart';
import 'package:portfolio_kha/component/commons/radius_box.dart';

class SakeEffect extends ComponentEffectBase {
  SakeEffect({
    required super.componentEffectTo,
  }) {
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
        EffectController(
          duration: 0.1,
        ),
      ),
    ], infinite: true, onComplete: () {
      componentEffectTo.anchor = anchorOld;
      componentEffectTo.position -= vectorIncreadToCenter;
    });
    componentEffectTo.add(effect);
  }
}

class FloatingEffect extends ComponentEffectBase {
  FloatingEffect({
    required super.componentEffectTo,
  }) {
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
      onComplete: () {},
    );
    componentEffectTo.add(effect);
  }
}

class BoxBorderLightComponent extends PositionComponent {
  final List<Component> items;
  final PositionComponent componentEffectTo;
  final List<Color> colorsLinnear;
  final Color colorBackground;
  final double speed;
  final Vector2 sizeEffect;
  final double radius;
  final double borderWidth;
  BoxBorderLightComponent(
      {required this.componentEffectTo,
      required this.items,
      this.colorBackground = Colors.black,
      this.radius = 10,
      required this.colorsLinnear,
      required this.speed,
      required this.sizeEffect,
      required this.borderWidth,
      super.size});
  @override
  FutureOr<void> onLoad() {
    add(_ConicGradientComponent(
        colors: colorsLinnear,
        rotationSpeed: speed,
        position: size / 2,
        radius: radius,
        sizeEffect: sizeEffect,
        borderWidth: borderWidth,
        size: size));
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
    final double maxSize = max(sizeEffect.x, sizeEffect.y);
    final double minSize = min(sizeEffect.x, sizeEffect.y);
    anchor = Anchor.center;
    _rect = Rect.fromLTWH(-maxSize / 2, -minSize / 2, maxSize, minSize);
    _rectClip = RRect.fromRectAndRadius(
        Rect.fromLTWH(-width / 2 - borderWidth / 2, -height / 2 - borderWidth / 2, size.x + borderWidth, size.y + borderWidth),
        Radius.circular(radius));

    _shadowPaint = Paint()
      // ..maskFilter =  MaskFilter.blur(BlurStyle.normal, blur)
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: colors,
      ).createShader(_rect.inflate(inflate));

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
  })  : _currentMoney = initialMoney,
        _targetMoney = initialMoney;
  @override
  FutureOr<void> onLoad() {
    textComponent = TextComponent(text: '$_currentMoney', textRenderer: textPaint);
    add(textComponent);
    return super.onLoad();
  }

  void changeMoney(int newMoney, double duration) {
    if (isMounted) {
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
      if ((_changeRate > 0 && _currentMoney > _targetMoney) || (_changeRate < 0 && _currentMoney < _targetMoney)) {
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
    required double scaleFrom,
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
        EffectController(duration: duration, curve: Curves.bounceOut, infinite: isLoop),
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
  final List<String> idItemsGet;
  final List<String> allItemsId;
  final Image imageItemsWheel;
  final void Function() onStartWheel;
  final void Function() onCompleteWheel;
  final Vector2 sizeItem;
  final double spinDuration;
  final List<ColumnSlotMachineReel> columnsItems = [];
  bool isSpinning = false;

  SlotMachineReel(
      {required this.allItemsId,
      required this.idItemsGet,
      required this.onStartWheel,
      required this.onCompleteWheel,
      required this.sizeItem,
      required this.imageItemsWheel,
      this.spinDuration = 3.0,
      super.size})
      : assert(idItemsGet.length >= 3, 'Need at least 3 items in the wheel') {
    for (int i = 0; i < idItemsGet.length; i++) {
      columnsItems.add(ColumnSlotMachineReel(
        items: allItemsId,
        sizeItem: sizeItem,
        index: i,
        slotMachineReel: this,
        imageItemsWheel: imageItemsWheel,
        targetItem: idItemsGet[i],
        spinDuration: spinDuration + (i * 0.5), // Each reel spins slightly longer
      ));
    }
  }

  void startWheel() {
    if (!isSpinning) {
      isSpinning = true;
      onStartWheel();
      for (var column in columnsItems) {
        column.startSpin();
      }
      Future.delayed(Duration(milliseconds: (spinDuration * 1000).round()), () {
        isSpinning = false;
        onCompleteWheel();
      });
    }
  }

  @override
  FutureOr<void> onLoad() {
    width = sizeItem.x * idItemsGet.length;
    height = sizeItem.y;
    add(ClipComponent(
      children: columnsItems,
      builder: (size) => Rectangle.fromLTWH(0, 0, width, height),
    ));
    return super.onLoad();
  }
}

class ColumnSlotMachineReel extends PositionComponent {
  final Vector2 sizeItem;
  final int index;
  final List<String> items;
  final SlotMachineReel slotMachineReel;
  final Image imageItemsWheel;
  final String targetItem;
  final double spinDuration;
  final List<SpriteComponent> spriteItemsImage = [];
  double currentOffset = 0;
  double spinSpeed = 0;
  bool isSpinning = false;
  double spinTime = 0;
  ColumnSlotMachineReel({
    required this.items,
    required this.sizeItem,
    required this.index,
    required this.slotMachineReel,
    required this.imageItemsWheel,
    required this.targetItem,
    required this.spinDuration,
  });
  void startSpin() {
    if (!isSpinning) {
      isSpinning = true;
      spinTime = 0;
      spinSpeed = 2000;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isSpinning) {
      spinTime += dt;

      // Implement smooth deceleration using easing
      if (spinTime > spinDuration * 0.5) {
        final progress = (spinTime - spinDuration * 0.5) / (spinDuration * 0.5);
        spinSpeed = 2000 * (1 - _easeOutCubic(progress)) + 50;
      }

      currentOffset += spinSpeed * dt;
      currentOffset = currentOffset % (sizeItem.y * items.length);

      // Improved circular buffer for continuous display
      final double totalHeight = sizeItem.y * items.length;

      // Update first sprite
      double yPos1 = currentOffset;
      if (yPos1 > totalHeight) {
        yPos1 -= totalHeight;
      }
      spriteItemsImage[0].position.y = yPos1;

      // Update second sprite to maintain continuous display
      double yPos2 = yPos1 - totalHeight;
      if (yPos2 < -totalHeight) {
        yPos2 += totalHeight;
      }
      spriteItemsImage[1].position.y = yPos2;

      if (spinTime >= spinDuration) {
        isSpinning = false;
        int targetIndex = items.indexOf(targetItem);
        currentOffset = targetIndex * sizeItem.y;

        // Ensure proper positioning of both sprites at the end
        spriteItemsImage[0].position.y = currentOffset;
        spriteItemsImage[1].position.y = currentOffset - sizeItem.y * items.length;
      }
    }
  }

  // Cubic easing function for smooth deceleration
  double _easeOutCubic(double t) {
    return 1 - pow(1 - t, 3).toDouble();
  }

  @override
  FutureOr<void> onLoad() {
    size = Vector2(sizeItem.x, sizeItem.y);
    anchor = Anchor.topLeft;

    for (int i = 0; i < 2; i++) {
      final sprite = SpriteComponent.fromImage(
        imageItemsWheel,
        size: Vector2(sizeItem.x, sizeItem.y * items.length),
        position: Vector2(0, i == 0 ? 0 : -sizeItem.y * items.length),
        anchor: Anchor.topLeft,
      );
      spriteItemsImage.add(sprite);
      add(sprite);
    }

    position = Vector2(index * sizeItem.x, 0);
    return super.onLoad();
  }
}
