import 'package:flame/components.dart';
import 'package:portfolio_kha/mixins/layout_mixin/size_component_provider.dart';

class GridComponent extends PositionComponent with SizeComponentProvider {
  GridComponent({
    required this.columns,
    required this.rows,
    this.cellSize = 32,
    this.spacing = 0,
    this.runSpacing = 0,
    super.position,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
  }) : super(
    size: Vector2(
      columns * cellSize + (columns - 1) * spacing,
      rows * cellSize + (rows - 1) * runSpacing,
    )
  );

  final int columns;
  
  final int rows;
  
  final double cellSize;
  
  final double spacing;
  
  final double runSpacing;

  Vector2 getCellPosition(int column, int row) {
    if (column >= columns || row >= rows) {
      throw ArgumentError('Column or row index out of bounds');
    }
    
    final x = column * (cellSize + spacing);
    final y = row * (cellSize + runSpacing);
    return Vector2(x, y);
  }

  (int column, int row)? getCellIndices(Vector2 position) {
    if (!containsPoint(position)) return null;

    final column = position.x ~/ (cellSize + spacing);
    final row = position.y ~/ (cellSize + runSpacing);
    
    if (column >= columns || row >= rows) return null;
    
    return (column, row);
  }
}
