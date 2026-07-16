import 'dart:async';
import 'package:flutter/material.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theme/app_theme.dart';
// import '../../../core/widgets/language_toggle.dart';

class MemoryMatchPage extends StatefulWidget {
  const MemoryMatchPage({super.key});

  @override
  State<MemoryMatchPage> createState() => _MemoryMatchPageState();
}

class _MemoryMatchPageState extends State<MemoryMatchPage> {
  // 6 pairs for a 3-column x 4-row grid (12 cards total) - Perfect for small kids
  final List<String> _emojiChoices = ["🐶", "🐱", "🍎", "🚗", "🌟", "🎈"];
  late List<String> _cards;
  late List<bool> _isFlipped;
  late List<bool> _isMatched;

  // Track recently matched indexes for the "correct match" animation
  List<int> _recentMatchIndexes = [];

  int? _previousIndex;
  bool _isProcessing = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _cards = [..._emojiChoices, ..._emojiChoices];
    _cards.shuffle();
    _isFlipped = List<bool>.filled(12, false);
    _isMatched = List<bool>.filled(12, false);
    _previousIndex = null;
    _isProcessing = false;
    _score = 0;
    _recentMatchIndexes = [];
    setState(() {});
  }

  String _getWordForEmoji(String emoji) {
    switch (emoji) {
      case "🐶":
        return "Dog";
      case "🐱":
        return "Cat";
      case "🍎":
        return "Apple";
      case "🚗":
        return "Car";
      case "🌟":
        return "Star";
      case "🎈":
        return "Balloon";
      default:
        return "";
    }
  }

  void _onCardTap(int index) async {
    if (_isProcessing || _isFlipped[index] || _isMatched[index]) {
      return;
    }

    setState(() {
      _isFlipped[index] = true;
    });

    String spokenWord = _getWordForEmoji(_cards[index]);
    AudioService().speak(spokenWord);

    if (_previousIndex == null) {
      _previousIndex = index;
    } else {
      _isProcessing = true;
      if (_cards[index] == _cards[_previousIndex!]) {
        // Match found!
        AudioService().speak("Good job!");
        final match1 = index;
        final match2 = _previousIndex!;

        setState(() {
          _isMatched[match1] = true;
          _isMatched[match2] = true;
          _recentMatchIndexes = [match1, match2];
          _score += 1;
        });

        _previousIndex = null;
        _isProcessing = false;

        if (_score == 6) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) _showWinDialog();
          });
        }
      } else {
        // No match
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        setState(() {
          _isFlipped[index] = false;
          _isFlipped[_previousIndex!] = false;
          _recentMatchIndexes = []; // clear matches just in case
        });
        _previousIndex = null;
        _isProcessing = false;
      }
    }
  }

  void _showWinDialog() {
    AudioService().speak("You win! Excellent!");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            "You Win! 🎉",
            style: AppTextStyle.nunito(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          content: Text(
            "Great job finding all the pairs!",
            style: AppTextStyle.nunito(
              color: AppTheme.textPrimary,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _startGame();
                },
                child: Text(
                  "Play Again",
                  style: AppTextStyle.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Memory Match",
          style: AppTextStyle.nunito(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentColor, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                            color: AppTheme.warning, size: 32)
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 2000.ms, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "Matches: $_score / 6",
                      style: AppTextStyle.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 500.ms).slideY(begin: -0.5, end: 0),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final bool isVisible =
                        _isFlipped[index] || _isMatched[index];

                    final bool isRecentMatch =
                        _recentMatchIndexes.contains(index);

                    Widget card = GestureDetector(
                      onTap: () => _onCardTap(index),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          // 3D Flip effect
                          final rotate =
                              Tween(begin: 3.14, end: 0.0).animate(animation);
                          return AnimatedBuilder(
                            animation: rotate,
                            child: child,
                            builder: (context, child) {
                              final isUnder =
                                  (ValueKey(isVisible) != child!.key);
                              var tilt =
                                  ((animation.value - 0.5).abs() - 0.5) * 0.003;
                              tilt *= isUnder ? -1.0 : 1.0;
                              return Transform(
                                transform: Matrix4.rotationY(rotate.value)
                                  ..setEntry(3, 0, tilt),
                                alignment: Alignment.center,
                                child: child,
                              );
                            },
                          );
                        },
                        child: isVisible
                            ? Container(
                                key: const ValueKey(true),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: isRecentMatch
                                          ? AppTheme.accentColor
                                          : AppTheme.secondaryColor,
                                      width: isRecentMatch ? 5 : 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isRecentMatch
                                          ? AppTheme.accentColor
                                              .withOpacity(0.6)
                                          : AppTheme.secondaryColor
                                              .withOpacity(0.3),
                                      blurRadius: isRecentMatch ? 15 : 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _cards[index],
                                    style: const TextStyle(fontSize: 50),
                                  ),
                                ),
                              )
                            : Container(
                                key: const ValueKey(false),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryColor,
                                      AppTheme.primaryColor.withOpacity(0.8)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor
                                          .withOpacity(0.4),
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "?",
                                    style: AppTextStyle.nunito(
                                      fontSize: 42,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    );

                    // Add entrance animation for the grid items
                    card = card
                        .animate(delay: (index * 50).ms)
                        .scale(duration: 400.ms, curve: Curves.easeOutBack)
                        .fade();

                    // If this card was just matched, add a celebration bounce and shimmer!
                    if (isRecentMatch) {
                      card = card
                          .animate(target: 1)
                          .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.15, 1.15),
                              duration: 300.ms,
                              curve: Curves.easeOutBack)
                          .then(delay: 200.ms)
                          .scale(
                              begin: const Offset(1.15, 1.15),
                              end: const Offset(1, 1),
                              duration: 300.ms)
                          .shimmer(
                              duration: 800.ms, color: AppTheme.accentColor);
                    }

                    return card;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
