import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/src/experimental/geometry/shapes/rectangle.dart';
enum ScrollComponentDirection { vertical, horizontal }

class ScrollComponent extends ClipComponent with DragCallbacks {
  double _scrollOffset = 0; // Vị trí cuộn hiện tại
  double _velocity = 0; // Tốc độ cuộn
  double boundaryMin = 0; // Ranh giới tối thiểu
  bool _isDragging = false;
ScrollComponentDirection direction = ScrollComponentDirection.vertical;
  final double damping = 300; // Hệ số giảm dần để mô phỏng hiệu ứng nảy

  double _maxSizeScrollListItem = 0;
  // late final double _maxHeightScrollValid;
  final List<PositionComponent> items;


  ScrollComponent({required super.size, required this.items, super.anchor, this.direction = ScrollComponentDirection.vertical})
  : super(
      builder: (size) {
        final double widthShop = size.x;
        final double heightShop = size.y;
        return Rectangle.fromLTWH(0, 0, widthShop, heightShop);
      },
    );

  double maxHeightChildrent() {
    final List<PositionComponent> childrenGet = children.query<PositionComponent>().toList();
    childrenGet.forEach((element) {
      final double positionY = element.positionOfAnchor(Anchor.bottomCenter).y;
      if (positionY > _maxSizeScrollListItem) {
        _maxSizeScrollListItem = positionY;
      }
    });
    // _maxHeightScrollValid = (_maxSizeScrollListItem - size.y).clamp(0, _maxSizeScrollListItem);
    return _maxSizeScrollListItem;
  }

    _handleStopWhenNearMin () {
    if (_scrollOffset.abs() < 0.1) {
          _scrollOffset = boundaryMin;
    }
  }
  _handleStopWhenNearMax() {
    if((-1* _scrollOffset + size.y )- _maxSizeScrollListItem <= 0.1) {
      _scrollOffset = -_maxSizeScrollListItem + size.y;

    }
  }
  @override
  void update(double dt) {
    
    if (!_isDragging) {
      if ((-1* _scrollOffset + size.y )> _maxSizeScrollListItem) {
        _velocity = -_scrollOffset * damping * dt; 
        _scrollOffset += _velocity * dt; 
        _handleUpdateItems(-_velocity* dt);
        _handleStopWhenNearMax();

      } else if (_scrollOffset > boundaryMin) {
        _velocity = -_scrollOffset * damping * dt; 
        _scrollOffset += _velocity * dt; 
        _handleUpdateItems(-_velocity* dt);

        _handleStopWhenNearMin();
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

 

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final double deltaY = event.deviceDelta.y;

    _isDragging = true;
    _scrollOffset += deltaY;
    // _velocity = 0; 
    _handleUpdateItems(-deltaY);



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
     
        if(direction == ScrollComponentDirection.vertical) {
         (child as PositionComponent).position.y -= valueOffset;
      } else {
        (child as PositionComponent).position.x -= valueOffset;
      }
    }
  }
}
