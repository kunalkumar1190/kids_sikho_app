import 'package:equatable/equatable.dart';
import '../models/number_model.dart';

abstract class NumbersState extends Equatable {
  const NumbersState();
  
  @override
  List<Object> get props => [];
}

class NumbersInitial extends NumbersState {}

class NumbersLoading extends NumbersState {}

class NumbersLoaded extends NumbersState {
  final List<NumberModel> numbers;

  const NumbersLoaded(this.numbers);

  @override
  List<Object> get props => [numbers];
}

class NumbersError extends NumbersState {
  final String message;

  const NumbersError(this.message);

  @override
  List<Object> get props => [message];
}
