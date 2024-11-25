import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/src/experimental/geometry/shapes/rectangle.dart';

class ScrollComponent extends ClipComponent with DragCallbacks {
  double scrollOffset = 0.0;
  double _maxHeightListItem = 0;
  late final double _maxHeightScrollValid;
  final List<PositionComponent> items;

  double maxHeightChildrent() {
    final List<PositionComponent> childrenGet =
        children.query<PositionComponent>().toList();
    childrenGet.forEach((element) {
      final double positionY = element.positionOfAnchor(Anchor.bottomCenter).y;
      if (positionY > _maxHeightListItem) {
        _maxHeightListItem = positionY;
      }
    });
    _maxHeightScrollValid =
        (_maxHeightListItem - size.y).clamp(0, _maxHeightListItem);
    return _maxHeightListItem;
  }

  @override
  void onMount() {
    maxHeightChildrent();
    // TODO: implement onMount
    super.onMount();
  }

  ScrollComponent({required super.size, required this.items, super.anchor})
      : super(
          builder: (size) {
            final double widthShop = size.x;
            final double heightShop = size.y;
            return Rectangle.fromLTWH(0, 0, widthShop, heightShop);
          },
        );

  _handleMoveItems(double deltaY) {
    final double delTaHandle = -(deltaY * 1.35);
    scrollOffset += delTaHandle;
    if (scrollOffset <= 0) {
      scrollOffset -= delTaHandle;
    } else if (scrollOffset >= _maxHeightScrollValid) {
      scrollOffset -= delTaHandle;
    } else {
      _handleUpdateItems(delTaHandle);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final double deltaY = event.deviceDelta.y;
    _handleMoveItems(deltaY);

    super.onDragUpdate(event);
  }

  @override
  Future<void> onLoad() async {
    priority = 99999999;
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
