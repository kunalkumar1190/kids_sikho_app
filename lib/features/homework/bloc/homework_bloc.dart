import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'homework_event.dart';
import 'homework_state.dart';
import '../data/models/homework_item.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  List<HomeworkItem> _items = [];
  int _currentIndex = 0;

  HomeworkBloc() : super(HomeworkInitial()) {
    on<LoadHomeworkEvent>(_onLoadHomework);
    on<CheckHomeworkEvent>(_onCheckHomework);
    on<NextHomeworkEvent>(_onNextHomework);
  }

  Future<void> _onLoadHomework(
      LoadHomeworkEvent event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/homework.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _items = jsonList.map((json) => HomeworkItem.fromJson(json)).toList();
      _currentIndex = 0;
      emit(HomeworkLoaded(currentItem: _items[_currentIndex]));
    } catch (e) {
      emit(HomeworkError(message: "Failed to load homework data"));
    }
  }

  void _onCheckHomework(CheckHomeworkEvent event, Emitter<HomeworkState> emit) {
    if (state is! HomeworkLoaded && state is! HomeworkFail) return;

    if (event.result.percentage >= 70) {
      emit(HomeworkSuccess(currentItem: _items[_currentIndex], result: event.result));
    } else {
      emit(HomeworkFail(currentItem: _items[_currentIndex], result: event.result));
    }
  }

  void _onNextHomework(NextHomeworkEvent event, Emitter<HomeworkState> emit) {
    _currentIndex = (_currentIndex + 1) % _items.length;
    emit(HomeworkLoaded(currentItem: _items[_currentIndex]));
  }
}
