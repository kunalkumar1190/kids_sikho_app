import '../data/models/fruit_model.dart';

abstract class FruitsState {}

class FruitsInitial extends FruitsState {}

class FruitsLoading extends FruitsState {}

class FruitsLoaded extends FruitsState {
  final List<FruitModel> fruits;
  FruitsLoaded(this.fruits);
}

class FruitsError extends FruitsState {
  final String message;
  FruitsError(this.message);
}
