import 'package:flutter/material.dart';
import '../utils/accuracy_calculator.dart';

@immutable
abstract class HomeworkEvent {}

class LoadHomeworkEvent extends HomeworkEvent {}

class CheckHomeworkEvent extends HomeworkEvent {
  final AccuracyResult result;
  CheckHomeworkEvent({required this.result});
}

class NextHomeworkEvent extends HomeworkEvent {}
