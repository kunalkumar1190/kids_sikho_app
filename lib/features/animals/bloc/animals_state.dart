import '../data/models/animal_model.dart';

abstract class AnimalsState {}

class AnimalsInitial extends AnimalsState {}

class AnimalsLoading extends AnimalsState {}

class AnimalsLoaded extends AnimalsState {
  final List<AnimalModel> animals;
  AnimalsLoaded(this.animals);
}

class AnimalsError extends AnimalsState {
  final String message;
  AnimalsError(this.message);
}
