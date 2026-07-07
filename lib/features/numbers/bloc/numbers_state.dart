import '../models/number_model.dart';

abstract class NumbersState {
  const NumbersState();
}

class NumbersInitial extends NumbersState {}

class NumbersLoading extends NumbersState {}

class NumbersLoaded extends NumbersState {
  final List<NumberModel> numbers;

  const NumbersLoaded(this.numbers);
}

class NumbersError extends NumbersState {
  final String message;

  const NumbersError(this.message);
}
