import 'package:flame/components.dart';

class GridComponent extends PositionComponent {
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

  /// Number of columns in the grid
  final int columns;
  
  /// Number of rows in the grid
  final int rows;
  
  /// Size of each cell (width and height)
  final double cellSize;
  
  /// Horizontal spacing between cells
  final double spacing;
  
  /// Vertical spacing between rows
  final double runSpacing;

  /// Get the position of a cell at given row and column
  Vector2 getCellPosition(int column, int row) {
    if (column >= columns || row >= rows) {
      throw ArgumentError('Column or row index out of bounds');
    }
    
    final x = column * (cellSize + spacing);
    final y = row * (cellSize + runSpacing);
    return Vector2(x, y);
  }

  /// Get the cell indices (column, row) at a given position
  (int column, int row)? getCellIndices(Vector2 position) {
    if (!containsPoint(position)) return null;

    final column = position.x ~/ (cellSize + spacing);
    final row = position.y ~/ (cellSize + runSpacing);
    
    if (column >= columns || row >= rows) return null;
    
    return (column, row);
  }
}
