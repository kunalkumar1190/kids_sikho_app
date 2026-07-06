import 'package:equatable/equatable.dart';

abstract class NumbersEvent extends Equatable {
  const NumbersEvent();

  @override
  List<Object> get props => [];
}

class LoadNumbers extends NumbersEvent {}
