part of 'drawing_bloc.dart';

abstract class DrawingEvent {
  const DrawingEvent();
}

class AddDrawingPoint extends DrawingEvent {
  final DrawingPoint point;
  const AddDrawingPoint(this.point);
}

class EndDrawingStroke extends DrawingEvent {}

class ClearDrawing extends DrawingEvent {}

class ChangeColor extends DrawingEvent {
  final Color color;
  const ChangeColor(this.color);
}

class ChangeStrokeWidth extends DrawingEvent {
  final double strokeWidth;
  const ChangeStrokeWidth(this.strokeWidth);
}

class UndoDrawing extends DrawingEvent {}
