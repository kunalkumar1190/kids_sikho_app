import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shapes_event.dart';
import 'shapes_state.dart';
import '../models/shape_model.dart';

class ShapesBloc extends Bloc<ShapesEvent, ShapesState> {
  ShapesBloc() : super(ShapesInitial()) {
    on<LoadShapes>(_onLoadShapes);
  }

  Future<void> _onLoadShapes(
      LoadShapes event, Emitter<ShapesState> emit) async {
    emit(ShapesLoading());
    try {
      final String response =
          await rootBundle.loadString('assets/data/shapes.json');
      final data = await json.decode(response) as List;
      
      final shapes = data
          .map((item) => ShapeModel.fromJson(item as Map<String, dynamic>))
          .toList();
          
      emit(ShapesLoaded(shapes));
    } catch (e) {
      emit(ShapesError(e.toString()));
    }
  }
}
