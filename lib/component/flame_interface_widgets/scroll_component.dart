import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/src/experimental/geometry/shapes/rectangle.dart';

class ScrollComponent extends ClipComponent with DragCallbacks {
  double _scrollOffset = 0; // Vị trí cuộn hiện tại
  double _velocity = 0; // Tốc độ cuộn
  double boundaryMin = 0; // Ranh giới tối thiểu
  bool _isDragging = false;

  final double damping = 300; // Hệ số giảm dần để mô phỏng hiệu ứng nảy

  double _maxHeightListItem = 0;
  late final double _maxHeightScrollValid;
  final List<PositionComponent> items;



  double maxHeightChildrent() {
    final List<PositionComponent> childrenGet = children.query<PositionComponent>().toList();
    childrenGet.forEach((element) {
      final double positionY = element.positionOfAnchor(Anchor.bottomCenter).y;
      if (positionY > _maxHeightListItem) {
        _maxHeightListItem = positionY;
      }
    });
    _maxHeightScrollValid = (_maxHeightListItem - size.y).clamp(0, _maxHeightListItem);
    return _maxHeightListItem;
  }
  @override
  void update(double dt) {
    
        if (!_isDragging) {
      print("${_scrollOffset} ${boundaryMin}");
      // Kiểm tra nếu vượt qua ranh giới
      if (_scrollOffset < boundaryMin) {
        _velocity = -_scrollOffset * damping * dt; 

        _scrollOffset += _velocity * dt; // Cập nhật vị trí
        _handleUpdateItems(_velocity * dt);

        if (_scrollOffset.abs() < 0.1) {
         _handleUpdateItems(boundaryMin - _scrollOffset);

          _scrollOffset = boundaryMin;

        } // Dừng khi gần ranh giới
      } else if (_scrollOffset > _maxHeightListItem) {
        _velocity = (_maxHeightListItem - _scrollOffset) * damping * dt;
        _scrollOffset += _velocity * dt;
        _handleUpdateItems(_velocity * dt);

        if ((_maxHeightListItem - _scrollOffset).abs() < 0.1) _scrollOffset = _maxHeightListItem;
      } else {
        // Nếu không vượt qua ranh giới, giảm tốc tự nhiên
        _velocity *= 0.9; // Giảm tốc độ dần
        _scrollOffset += _velocity * dt;
      }
    }
   
    super.update(dt);
  }
  @override
  void onDragEnd(DragEndEvent event) {
    _isDragging = false;    
    super.onDragEnd(event);
  }
  @override
  void onDragCancel(DragCancelEvent event) {
    _isDragging = false;    
    super.onDragCancel(event);
  }
  @override
  void onMount() {
    super.onMount();

    maxHeightChildrent();
    // TODO: implement onMount
  }

  ScrollComponent({required super.size, required this.items, super.anchor})
      : super(
          builder: (size) {
            final double widthShop = size.x;
            final double heightShop = size.y;
            return Rectangle.fromLTWH(0, 0, widthShop, heightShop);
          },
        );


  @override
  void onDragUpdate(DragUpdateEvent event) {
    final double deltaY = event.deviceDelta.y;

    _isDragging = true;
    _scrollOffset += deltaY;
    _velocity = 0; 


    super.onDragUpdate(event);
  }

  @override
  Future<void> onLoad() async {
    priority = 99999999;
    debugMode = true;
    // anchor = Anchor.topCenter;
    await addAll(items);
    super.onLoad();
  }

  _handleUpdateItems(double valueOffset) {
    for (final child in children.where((a) => a is PositionComponent)) {
      (child as PositionComponent).position.y -= valueOffset;
    }
  }
}
