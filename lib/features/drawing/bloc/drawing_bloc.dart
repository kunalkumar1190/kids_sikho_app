import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/drawing_point.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  DrawingBloc() : super(const DrawingState()) {
    on<AddDrawingPoint>(_onAddDrawingPoint);
    on<EndDrawingStroke>(_onEndDrawingStroke);
    on<ClearDrawing>(_onClearDrawing);
    on<ChangeColor>(_onChangeColor);
    on<ChangeStrokeWidth>(_onChangeStrokeWidth);
    on<UndoDrawing>(_onUndoDrawing);
  }

  void _onAddDrawingPoint(AddDrawingPoint event, Emitter<DrawingState> emit) {
    final updatedPoints = List<DrawingPoint?>.from(state.points)..add(event.point);
    emit(state.copyWith(points: updatedPoints));
  }

  void _onEndDrawingStroke(EndDrawingStroke event, Emitter<DrawingState> emit) {
    final updatedPoints = List<DrawingPoint?>.from(state.points)..add(null);
    emit(state.copyWith(points: updatedPoints));
  }

  void _onClearDrawing(ClearDrawing event, Emitter<DrawingState> emit) {
    final updatedHistory = List<List<DrawingPoint?>>.from(state.undoHistory)..add(state.points);
    emit(state.copyWith(points: [], undoHistory: updatedHistory));
  }

  void _onChangeColor(ChangeColor event, Emitter<DrawingState> emit) {
    emit(state.copyWith(selectedColor: event.color));
  }

  void _onChangeStrokeWidth(ChangeStrokeWidth event, Emitter<DrawingState> emit) {
    emit(state.copyWith(strokeWidth: event.strokeWidth));
  }

  void _onUndoDrawing(UndoDrawing event, Emitter<DrawingState> emit) {
    if (state.points.isNotEmpty) {
      // Find the last null (end of stroke) and remove everything after it
      final points = List<DrawingPoint?>.from(state.points);
      
      // If the last point is null (end of stroke), we remove it first
      if (points.isNotEmpty && points.last == null) {
        points.removeLast();
      }
      
      // Remove points until we hit another null (previous stroke) or empty
      while (points.isNotEmpty && points.last != null) {
        points.removeLast();
      }

      emit(state.copyWith(points: points));
    }
  }
}
