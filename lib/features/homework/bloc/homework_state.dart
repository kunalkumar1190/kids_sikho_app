import 'package:flutter/material.dart';
import '../data/models/homework_item.dart';
import '../utils/accuracy_calculator.dart';

@immutable
abstract class HomeworkState {}

class HomeworkInitial extends HomeworkState {}

class HomeworkLoading extends HomeworkState {}

class HomeworkLoaded extends HomeworkState {
  final HomeworkItem currentItem;
  HomeworkLoaded({required this.currentItem});
}

class HomeworkSuccess extends HomeworkState {
  final HomeworkItem currentItem;
  final AccuracyResult result;
  HomeworkSuccess({required this.currentItem, required this.result});
}

class HomeworkFail extends HomeworkState {
  final HomeworkItem currentItem;
  final AccuracyResult result;
  HomeworkFail({required this.currentItem, required this.result});
}

class HomeworkError extends HomeworkState {
  final String message;
  HomeworkError({required this.message});
}
