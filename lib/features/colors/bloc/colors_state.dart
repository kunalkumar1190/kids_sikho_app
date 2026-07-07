import '../data/models/color_model.dart';

abstract class ColorsState {}

class ColorsInitial extends ColorsState {}

class ColorsLoading extends ColorsState {}

class ColorsLoaded extends ColorsState {
  final List<ColorModel> colors;
  ColorsLoaded(this.colors);
}

class ColorsError extends ColorsState {
  final String message;
  ColorsError(this.message);
}
