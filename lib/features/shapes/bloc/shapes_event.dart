import 'package:equatable/equatable.dart';

abstract class ShapesEvent extends Equatable {
  const ShapesEvent();

  @override
  List<Object> get props => [];
}

class LoadShapes extends ShapesEvent {}
