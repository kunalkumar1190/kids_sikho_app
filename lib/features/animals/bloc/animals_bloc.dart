import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'animals_event.dart';
import 'animals_state.dart';
import '../data/models/animal_model.dart';

class AnimalsBloc extends Bloc<AnimalsEvent, AnimalsState> {
  AnimalsBloc() : super(AnimalsInitial()) {
    on<LoadAnimals>(_onLoadAnimals);
  }

  Future<void> _onLoadAnimals(
      LoadAnimals event, Emitter<AnimalsState> emit) async {
    emit(AnimalsLoading());
    try {
      final String response =
          await rootBundle.loadString('assets/data/animals.json');
      final data = await json.decode(response) as List;
      final animals = data
          .map((item) => AnimalModel.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(AnimalsLoaded(animals));
    } catch (e) {
      emit(AnimalsError(e.toString()));
    }
  }
}
