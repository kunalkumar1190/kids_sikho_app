part of 'drawing_bloc.dart';

class DrawingState {
  final List<DrawingPoint?> points;
  final List<List<DrawingPoint?>> undoHistory;
  final Color selectedColor;
  final double strokeWidth;

  const DrawingState({
    this.points = const [],
    this.undoHistory = const [],
    this.selectedColor = Colors.black,
    this.strokeWidth = 5.0,
  });

  DrawingState copyWith({
    List<DrawingPoint?>? points,
    List<List<DrawingPoint?>>? undoHistory,
    Color? selectedColor,
    double? strokeWidth,
  }) {
    return DrawingState(
      points: points ?? this.points,
      undoHistory: undoHistory ?? this.undoHistory,
      selectedColor: selectedColor ?? this.selectedColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}
