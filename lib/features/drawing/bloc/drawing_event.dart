part of 'drawing_bloc.dart';

abstract class DrawingEvent extends Equatable {
  const DrawingEvent();

  @override
  List<Object?> get props => [];
}

class AddDrawingPoint extends DrawingEvent {
  final DrawingPoint point;
  const AddDrawingPoint(this.point);

  @override
  List<Object?> get props => [point];
}

class EndDrawingStroke extends DrawingEvent {}

class ClearDrawing extends DrawingEvent {}

class ChangeColor extends DrawingEvent {
  final Color color;
  const ChangeColor(this.color);

  @override
  List<Object?> get props => [color];
}

class ChangeStrokeWidth extends DrawingEvent {
  final double strokeWidth;
  const ChangeStrokeWidth(this.strokeWidth);

  @override
  List<Object?> get props => [strokeWidth];
}

class UndoDrawing extends DrawingEvent {}
