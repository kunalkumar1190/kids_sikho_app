import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'colors_event.dart';
import 'colors_state.dart';
import '../data/models/color_model.dart';

class ColorsBloc extends Bloc<ColorsEvent, ColorsState> {
  ColorsBloc() : super(ColorsInitial()) {
    on<LoadColors>(_onLoadColors);
  }

  Future<void> _onLoadColors(
      LoadColors event, Emitter<ColorsState> emit) async {
    emit(ColorsLoading());
    try {
      final String response =
          await rootBundle.loadString('assets/data/colors.json');
      final data = await json.decode(response) as List;
      final colors = data
          .map((item) => ColorModel.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(ColorsLoaded(colors));
    } catch (e) {
      emit(ColorsError(e.toString()));
    }
  }
}
