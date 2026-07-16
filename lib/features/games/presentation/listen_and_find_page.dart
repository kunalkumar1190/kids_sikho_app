import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/settings/settings_cubit.dart';
import '../../../core/widgets/language_toggle.dart';

class ListenAndFindPage extends StatefulWidget {
  const ListenAndFindPage({super.key});

  @override
  State<ListenAndFindPage> createState() => _ListenAndFindPageState();
}

class _ListenAndFindPageState extends State<ListenAndFindPage> {
  final List<Map<String, String>> _allItems = [
    // Alphabets
    {"symbol": "A", "name_en": "the letter A", "name_hi": "अक्षर ए"},
    {"symbol": "B", "name_en": "the letter B", "name_hi": "अक्षर बी"},
    {"symbol": "C", "name_en": "the letter C", "name_hi": "अक्षर सी"},
    {"symbol": "D", "name_en": "the letter D", "name_hi": "अक्षर डी"},
    // Numbers
    {"symbol": "1", "name_en": "the number 1", "name_hi": "नंबर एक"},
    {"symbol": "2", "name_en": "the number 2", "name_hi": "नंबर दो"},
    {"symbol": "3", "name_en": "the number 3", "name_hi": "नंबर तीन"},
    {"symbol": "4", "name_en": "the number 4", "name_hi": "नंबर चार"},
    // Animals
    {"symbol": "🐶", "name_en": "the dog", "name_hi": "कुत्ता"},
    {"symbol": "🐱", "name_en": "the cat", "name_hi": "बिल्ली"},
    {"symbol": "🐘", "name_en": "the elephant", "name_hi": "हाथी"},
    {"symbol": "🐸", "name_en": "the frog", "name_hi": "मेंढक"},
    // Shapes & Colors
    {"symbol": "⭐", "name_en": "the star", "name_hi": "तारा"},
    {"symbol": "🔴", "name_en": "the red circle", "name_hi": "लाल वृत्त"},
    {"symbol": "🟦", "name_en": "the blue square", "name_hi": "नीला वर्ग"},
    {"symbol": "🍎", "name_en": "the apple", "name_hi": "सेब"},
  ];

  List<Map<String, String>> _currentOptions = [
    {"symbol": "A", "name_en": "the letter A", "name_hi": "अक्षर ए"},
    {"symbol": "1", "name_en": "the number 1", "name_hi": "नंबर एक"},
    {"symbol": "🐶", "name_en": "the dog", "name_hi": "कुत्ता"},
    {"symbol": "⭐", "name_en": "the star", "name_hi": "तारा"},
  ];
  Map<String, String> _targetItem = {
    "symbol": "A",
    "name_en": "the letter A",
    "name_hi": "अक्षर ए"
  };
  int _score = 0;
  bool _isProcessing = false;

  // Track which index got wrong to shake it
  int? _wrongIndex;
  // Track if success to animate
  bool _isSuccess = false;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLanguageSelectionDialog();
    });
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            "Choose Language\nभाषा चुनें",
            style: AppTextStyle.nunito(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption("English", false, Colors.blueAccent),
              const SizedBox(height: 16),
              _buildLanguageOption("Hindi (हिंदी)", true, Colors.green),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String title, bool isHindi, Color color) {
    return InkWell(
      onTap: () async {
        await context.read<SettingsCubit>().setLanguage(isHindi);
        if (mounted) {
          Navigator.pop(context);
          _startNewRound();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: 3,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyle.nunito(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  void _startNewRound() {
    setState(() {
      _isProcessing = false;
      _wrongIndex = null;
      _isSuccess = false;

      final shuffled = List<Map<String, String>>.from(_allItems)
        ..shuffle(_random);
      _currentOptions = shuffled.take(4).toList();
      _targetItem = _currentOptions[_random.nextInt(4)];
    });

    _askQuestion();
  }

  void _askQuestion() {
    final isHindi = context.read<SettingsCubit>().state;
    final targetName =
        isHindi ? _targetItem['name_hi'] : _targetItem['name_en'];
    final question = isHindi ? "$targetName कहाँ है?" : "Where is $targetName?";
    AudioService().speak(question, languageCode: isHindi ? 'hi-IN' : 'en-US');
  }

  void _onItemTap(int index) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final tappedItem = _currentOptions[index];
    final isHindi = context.read<SettingsCubit>().state;

    if (tappedItem == _targetItem) {
      // Correct!
      setState(() {
        _isSuccess = true;
        _score++;
      });
      final targetName =
          isHindi ? _targetItem['name_hi'] : _targetItem['name_en'];
      final msg = isHindi
          ? "बहुत बढ़िया! आपने $targetName खोज लिया!"
          : "Great job! You found $targetName!";
      AudioService().speak(msg, languageCode: isHindi ? 'hi-IN' : 'en-US');

      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        _startNewRound();
      }
    } else {
      // Wrong!
      setState(() {
        _wrongIndex = index;
      });
      final tappedName =
          isHindi ? tappedItem['name_hi'] : tappedItem['name_en'];
      final msg = isHindi
          ? "उफ़! वह $tappedName है। फिर से प्रयास करें!"
          : "Oops! That's $tappedName. Try again!";
      AudioService().speak(msg, languageCode: isHindi ? 'hi-IN' : 'en-US');

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _wrongIndex = null;
          _isProcessing = false;
        });
        _askQuestion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: Text(
          "Listen & Find",
          style: AppTextStyle.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.volume_up),
          //   onPressed: () {
          //     if (!_isProcessing) _askQuestion();
          //   },
          //   tooltip: 'Repeat Question',
          // ),
          const LanguageToggleWidget(),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Score: $_score",
                  style: AppTextStyle.fredoka(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (!_isProcessing) _askQuestion();
                  },
                  icon: const Icon(Icons.hearing),
                  label: const Text("Listen"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(30),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final isTarget = _currentOptions[index] == _targetItem;
                  Widget card = GestureDetector(
                    onTap: () => _onItemTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _currentOptions[index]['symbol']!,
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                  );

                  // Success animation for the correct item when won
                  if (_isSuccess && isTarget) {
                    card = card
                        .animate(onPlay: (controller) => controller.repeat())
                        .scale(duration: 500.ms, curve: Curves.easeInOut)
                        .then()
                        .scale(
                            begin: const Offset(1.2, 1.2),
                            end: const Offset(1.0, 1.0),
                            duration: 500.ms);
                  }

                  // Shake animation for wrong item
                  if (_wrongIndex == index) {
                    card = card.animate().shake(hz: 4, duration: 400.ms);
                  }

                  return card;
                },
              ),
            ),
          ),
          if (_isSuccess)
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                "Awesome! 🎉",
                style: AppTextStyle.fredoka(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ).animate().fade(duration: 300.ms).scale(duration: 300.ms),
            ),
        ],
      ),
    );
  }
}
