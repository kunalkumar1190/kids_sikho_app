import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'numbers_event.dart';
import 'numbers_state.dart';
import '../models/number_model.dart';

class NumbersBloc extends Bloc<NumbersEvent, NumbersState> {
  NumbersBloc() : super(NumbersInitial()) {
    on<LoadNumbers>(_onLoadNumbers);
  }

  Future<void> _onLoadNumbers(
      LoadNumbers event, Emitter<NumbersState> emit) async {
    emit(NumbersLoading());
    try {
      final String response =
          await rootBundle.loadString('assets/data/numbers.json');
      final data = await json.decode(response) as List;
      
      final numbers = data
          .map((item) => NumberModel.fromJson(item as Map<String, dynamic>))
          .toList();
          
      emit(NumbersLoaded(numbers));
    } catch (e) {
      emit(NumbersError(e.toString()));
    }
  }
}
