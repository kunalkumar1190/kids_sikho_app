import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'alphabet_event.dart';
import 'alphabet_state.dart';

class AlphabetBloc extends Bloc<AlphabetEvent, AlphabetState> {
  AlphabetBloc() : super(AlphabetInitial()) {
    on<LoadAlphabet>(_onLoadAlphabet);
  }

  Future<void> _onLoadAlphabet(
      LoadAlphabet event, Emitter<AlphabetState> emit) async {
    emit(AlphabetLoading());
    try {
      final String response =
          await rootBundle.loadString('assets/data/alphabet.json');
      final data = await json.decode(response) as List;
      emit(AlphabetLoaded(data));
    } catch (e) {
      emit(AlphabetError(e.toString()));
    }
  }
}
