import '../models/shape_model.dart';

abstract class ShapesState {
  const ShapesState();
}

class ShapesInitial extends ShapesState {}

class ShapesLoading extends ShapesState {}

class ShapesLoaded extends ShapesState {
  final List<ShapeModel> shapes;

  const ShapesLoaded(this.shapes);
}

class ShapesError extends ShapesState {
  final String message;

  const ShapesError(this.message);
}
