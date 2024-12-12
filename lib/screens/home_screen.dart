import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
    // add(ScrollComponent(
    //     size: sizeScroll, 
    //     items: [
    //       WrapComponent(alignment: WrapAlignment.start, runSpacing: 10, spacing: ((sizeScroll.x - sizeItem.x * 3) / 2), children: [
    //         ...List.generate(listEffects.length, (index) {
    //           return ItemLibary(effect: listEffects[index], size: sizeItem);
    //         }),
         
            
    //       ])
    //     ],
        
    // )..position= Vector2(width*0.05, height*0.05));
    add(   BouncingScrollComponent(
              boundaryMin: 0,
              boundaryMax: 400,
              size: Vector2(300, 300),
              position: Vector2(50, 50),
            ));
    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }
}

class ItemLibary extends PositionComponent {
  final Component Function(PositionComponent component) effect;
  ItemLibary({super.size, required this.effect}) ;
  @override
  void onMount() {
    // TODO: implement onMount

    add(effect(this));
    super.onMount();
  }
}






class BouncingScrollComponent extends PositionComponent with DragCallbacks {
  double _scrollOffset = 0; // Vị trí cuộn hiện tại
  double _velocity = 0; // Tốc độ cuộn
  double boundaryMin; // Ranh giới tối thiểu
  double boundaryMax; // Ranh giới tối đa
  bool _isDragging = false;

  final double damping = 300; // Hệ số giảm dần để mô phỏng hiệu ứng nảy

  BouncingScrollComponent({
    required this.boundaryMin,
    required this.boundaryMax,
    super.size,
    super.position,
  }){
    debugMode = true;
  }
  @override
  void onDragUpdate(DragUpdateEvent event) {
    final double deltaY = event.deviceDelta.y;
    _isDragging = true;
    _scrollOffset += deltaY;
    _velocity = 0; 

    super.onDragUpdate(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _isDragging = false;

    super.onDragCancel(event);
  }
  @override
  void onDragEnd(DragEndEvent event) {
    _isDragging = false;

    super.onDragEnd(event);
  }
  _handleStopWhenNearMin () {
    if (_scrollOffset.abs() < 0.1) {
          _scrollOffset = boundaryMin;
        }// Dừng khi gần ranh giới
  }
  _handleStopWhenNearMax() {
    if((-1* _scrollOffset + size.y )- boundaryMax <= 0.1) {
      _scrollOffset = -boundaryMax + size.y;

    }
  }
  @override
  void update(double dt) {
    super.update(dt);

    if (!_isDragging) {
      // Kiểm tra nếu vượt qua ranh giới
      if ((-1* _scrollOffset + size.y )> boundaryMax) {
        _velocity = -_scrollOffset * damping * dt; // Tốc độ nảy về
        _scrollOffset += _velocity * dt; // Cập nhật vị trí
        _handleStopWhenNearMax();

      } else if (_scrollOffset > boundaryMin) {
        _velocity = -_scrollOffset * damping * dt; // Tốc độ nảy về
        _scrollOffset += _velocity * dt; // Cập nhật vị trí
        _handleStopWhenNearMin();
      } 
      //  else if (_scrollOffset > boundaryMax) {
      //   _velocity = (boundaryMax - _scrollOffset) * damping * dt;
      //   _scrollOffset += _velocity * dt;
      //   if ((boundaryMax - _scrollOffset).abs() < 0.1) _scrollOffset = boundaryMax;
      // } else {
      //   _velocity *= 0.9; 
      //   _scrollOffset += _velocity * dt;
    
      //   _handleStopWhenNearMin();
      // }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Vẽ nội dung (tùy chỉnh theo ứng dụng của bạn)
    final paint = Paint()..color = const Color(0xFF00FF00);
    final rect = Rect.fromLTWH(0, _scrollOffset, size.x, 100);
    canvas.drawRect(rect, paint);

    final paint2 = Paint()..color = const Color.fromARGB(255, 255, 4, 0);
    final rect2 = Rect.fromLTWH(0, _scrollOffset+ 100, size.x, 100);
    canvas.drawRect(rect2, paint2);

  final paint3 = Paint()..color = const Color.fromARGB(255, 70, 38, 184);
    final rect3 = Rect.fromLTWH(0, _scrollOffset+ 200, size.x, 100);
    canvas.drawRect(rect3, paint3);
    final paint4= Paint()..color = const Color.fromARGB(255, 70, 38, 184);
    final rect4= Rect.fromLTWH(0, _scrollOffset+ 300, size.x, 100);
    canvas.drawRect(rect4, paint4);
  }
}