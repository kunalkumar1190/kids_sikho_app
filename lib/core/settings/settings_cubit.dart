import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<bool> {
  static const String _langKey = "isHindi";

  SettingsCubit() : super(false) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isHindi = prefs.getBool(_langKey) ?? false;
    emit(isHindi);
  }

  Future<void> setLanguage(bool isHindi) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_langKey, isHindi);
    emit(isHindi);
  }
}
