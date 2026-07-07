import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fruits_event.dart';
import 'fruits_state.dart';
import '../data/models/fruit_model.dart';

class FruitsBloc extends Bloc<FruitsEvent, FruitsState> {
  FruitsBloc() : super(FruitsInitial()) {
    on<LoadFruits>(_onLoadFruits);
  }

  Future<void> _onLoadFruits(
      LoadFruits event, Emitter<FruitsState> emit) async {
    emit(FruitsLoading());
    try {
      final String response =
          await rootBundle.loadString('assets/data/fruits.json');
      final data = await json.decode(response) as List;
      final fruits = data
          .map((item) => FruitModel.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(FruitsLoaded(fruits));
    } catch (e) {
      emit(FruitsError(e.toString()));
    }
  }
}
