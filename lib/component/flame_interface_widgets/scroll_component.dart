import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/src/experimental/geometry/shapes/rectangle.dart';
enum ScrollComponentDirection { vertical, horizontal }

class ScrollComponent extends PositionComponent with DragCallbacks {
  double _scrollOffset = 0; // Vị trí cuộn hiện tại
  double _velocity = 0; // Tốc độ cuộn
  double boundaryMin = 0; // Ranh giới tối thiểu
  bool _isDragging = false;
ScrollComponentDirection direction = ScrollComponentDirection.vertical;
  final double damping = 300; // Hệ số giảm dần để mô phỏng hiệu ứng nảy

  double _maxSizeScrollListItem = 0;
  final List<PositionComponent> items;


  ScrollComponent({required super.size, required this.items, super.anchor, this.direction = ScrollComponentDirection.vertical})
  : super(
      // builder: (size) {
      //   final double widthShop = size.x;
      //   final double heightShop = size.y;
      //   return Rectangle.fromLTWH(0, 0, widthShop, heightShop);
      // },
    );

  void maxHeightChildrent() {
    final List<PositionComponent> childrenGet = children.query<PositionComponent>().toList();
    childrenGet.forEach((element) {
      final double positionY = element.positionOfAnchor(Anchor.bottomCenter).y;
      if (positionY > _maxSizeScrollListItem) {
        _maxSizeScrollListItem = positionY;
      }
    });
  }

  void maxWidtgChildrent() {
    final List<PositionComponent> childrenGet = children.query<PositionComponent>().toList();
    childrenGet.forEach((element) {
      final double positionX = element.positionOfAnchor(Anchor.centerRight).x;
      if (positionX > _maxSizeScrollListItem) {
        _maxSizeScrollListItem = positionX;
      }
    });
  }
    _handleStopWhenNearMin () {
    if (_scrollOffset.abs() < 0.1) {
          _scrollOffset = boundaryMin;
    }
  }
  _handleStopWhenNearMax() {
    final double sizeHandle = direction == ScrollComponentDirection.vertical ? size.y : size.x;
    if((-1* _scrollOffset + sizeHandle )- _maxSizeScrollListItem <= 0.1) {
      _scrollOffset = -_maxSizeScrollListItem + sizeHandle;

    }
  }
  @override
  void update(double dt) {
    final double sizeHandle = direction == ScrollComponentDirection.vertical ? size.y : size.x;
    
    if (!_isDragging) {
      if ((-1* _scrollOffset + sizeHandle )> _maxSizeScrollListItem) {
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
    if(direction == ScrollComponentDirection.vertical) {
      maxHeightChildrent();
    } else {
      maxWidtgChildrent();
    }
  }

 

  @override
  void onDragUpdate(DragUpdateEvent event) {
// event.deviceDelta.y;
    final double deltaHandle = direction == ScrollComponentDirection.vertical ? event.deviceDelta.y : event.deviceDelta.x;
    _isDragging = true;
    _scrollOffset += deltaHandle;
    // _velocity = 0; 
    _handleUpdateItems(-deltaHandle);



    super.onDragUpdate(event);
  }

  @override
  Future<void> onLoad() async {
    priority = 99999999;
    // ;
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
