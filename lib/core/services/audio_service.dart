import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  // Singleton pattern for global access
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  late FlutterTts _flutterTts;

  AudioService._internal() {
    _flutterTts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    // Configure for a friendly, human-like voice suitable for teaching kids
    await _flutterTts.setSpeechRate(0.45); // Slower for clarity
    await _flutterTts.setVolume(1.0);
    await _flutterTts
        .setPitch(1.1); // Slightly higher pitch to sound engaging and friendly
  }

  Future<void> speak(String text, {String languageCode = 'en-US'}) async {
    await _flutterTts.setLanguage(languageCode);
    
    // Customize voice based on language
    if (languageCode == 'hi-IN') {
      await _flutterTts.setSpeechRate(0.55); // Slightly faster for Hindi
      await _flutterTts.setPitch(1.3);       // Softer/higher pitch
      await _flutterTts.setVolume(0.8);      // Slightly softer volume
    } else {
      await _flutterTts.setSpeechRate(0.45); // Slower for English clarity
      await _flutterTts.setPitch(1.1);
      await _flutterTts.setVolume(1.0);
    }
    
    await _flutterTts.speak(text);
  }

  Future<void> pause() async {
    await _flutterTts.pause();
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void setCompletionHandler(void Function() handler) {
    _flutterTts.setCompletionHandler(handler);
  }
}
