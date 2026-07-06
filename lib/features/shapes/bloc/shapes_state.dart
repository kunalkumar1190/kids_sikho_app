import 'package:equatable/equatable.dart';
import '../models/shape_model.dart';

abstract class ShapesState extends Equatable {
  const ShapesState();
  
  @override
  List<Object> get props => [];
}

class ShapesInitial extends ShapesState {}

class ShapesLoading extends ShapesState {}

class ShapesLoaded extends ShapesState {
  final List<ShapeModel> shapes;

  const ShapesLoaded(this.shapes);

  @override
  List<Object> get props => [shapes];
}

class ShapesError extends ShapesState {
  final String message;

  const ShapesError(this.message);

  @override
  List<Object> get props => [message];
}
