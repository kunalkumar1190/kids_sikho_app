import 'dart:async';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sikho_basic/core/theme/app_text_style.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theme/app_theme.dart';
// import '../../../core/widgets/language_toggle.dart';

class MatchTheFollowingPage extends StatefulWidget {
  const MatchTheFollowingPage({super.key});

  @override
  State<MatchTheFollowingPage> createState() => _MatchTheFollowingPageState();
}

class _MatchTheFollowingPageState extends State<MatchTheFollowingPage> {
  // Dictionary of educational matching items
  final Map<String, String> _allData = {
    "🐶": "Dog",
    "🐱": "Cat",
    "🍎": "Apple",
    "🚗": "Car",
    "🌟": "Star",
    "🎈": "Balloon",
    "🦋": "Butterfly",
    "🐸": "Frog",
    "🦁": "Lion",
    "🐼": "Panda",
    "🌞": "Sun",
    "🌙": "Moon",
  };

  int _currentLevel = 1; // 1 to 3
  int _currentRound = 1; // 1 to 4

  bool _showTutorial = true;

  List<String> _leftItems = [];
  List<String> _rightItems = [];
  List<String> _matchedItems = [];

  @override
  void initState() {
    super.initState();
    _startRound();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showTutorial) {
        _showTutorialDialog();
      }
    });
  }

  int get _pairCount {
    if (_currentLevel == 1) return 2;
    if (_currentLevel == 2) return 4;
    return 6;
  }

  void _startRound() {
    // 1. Pick _pairCount random pairs
    final allKeys = _allData.keys.toList()..shuffle();
    final selectedKeys = allKeys.take(_pairCount).toList();

    // 2. Prepare left and right columns
    _leftItems = List.from(selectedKeys);
    _rightItems = List.from(selectedKeys);

    _leftItems.shuffle();
    _rightItems.shuffle();
    _matchedItems.clear();

    setState(() {});
  }

  void _showTutorialDialog() {
    AudioService().speak("Drag the picture to its matching name!");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            "How to Play",
            style: AppTextStyle.nunito(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("🍎", style: TextStyle(fontSize: 50)),
                  const Icon(Icons.arrow_forward_rounded,
                          color: AppTheme.secondaryColor, size: 40)
                      .animate(onPlay: (controller) => controller.repeat())
                      .moveX(begin: -10, end: 10, duration: 600.ms),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Apple",
                      style: AppTextStyle.nunito(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Drag the picture to its matching name!",
                style: AppTextStyle.nunito(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() => _showTutorial = false);
                },
                child: Text(
                  "Play!",
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

  void _onMatchSuccess(String emojiKey) async {
    AudioService().speak("Good job!");
    setState(() {
      _matchedItems.add(emojiKey);
    });

    if (_matchedItems.length == _pairCount) {
      // Round Complete
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      if (_currentRound < 4) {
        // Next round
        setState(() {
          _currentRound++;
        });
        _startRound();
      } else {
        // Level Complete
        if (_currentLevel < 3) {
          _showLevelCompleteDialog();
        } else {
          _showWinDialog();
        }
      }
    }
  }

  void _showLevelCompleteDialog() {
    AudioService().speak("Level Complete! Get ready for next level!");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            "Level $_currentLevel Complete! 🎉",
            style: AppTextStyle.nunito(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
            textAlign: TextAlign.center,
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          content: Text(
            "You did an amazing job!",
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
                  setState(() {
                    _currentLevel++;
                    _currentRound = 1;
                  });
                  _startRound();
                },
                child: Text(
                  "Next Level",
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

  void _showWinDialog() {
    AudioService().speak("You are a champion! You beat all levels!");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            "Champion! 🏆",
            style: AppTextStyle.nunito(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ).animate(),
          content: Text(
            "You finished all 3 levels. Great brain work!",
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
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentLevel = 1;
                    _currentRound = 1;
                  });
                  _startRound();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Match It!",
          style: AppTextStyle.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildStatusHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Left Column (Draggables)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _leftItems
                              .map((emoji) => _buildDraggableEmoji(emoji))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Right Column (DragTargets)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _rightItems
                              .map((emoji) => _buildDragTargetWord(emoji))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Level: $_currentLevel",
            style: AppTextStyle.nunito(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          Container(
            height: 30,
            width: 2,
            color: Colors.grey.shade300,
          ),
          Text(
            "Round: $_currentRound/4",
            style: AppTextStyle.nunito(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
        ],
      ),
    ).animate().fade().slideY();
  }

  Widget _buildDraggableEmoji(String emoji) {
    bool isMatched = _matchedItems.contains(emoji);

    if (isMatched) {
      return const SizedBox(); // Hide when matched
    }

    bool isFirstMove =
        _currentLevel == 1 && _currentRound == 1 && _matchedItems.isEmpty;
    bool isHintSource = isFirstMove && emoji == _leftItems.first;

    Widget emojiBox = Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
            color: isHintSource ? Colors.blueAccent : AppTheme.accentColor,
            width: isHintSource ? 5 : 3),
        boxShadow: [
          BoxShadow(
            color: isHintSource
                ? Colors.blueAccent.withOpacity(0.5)
                : AppTheme.accentColor.withOpacity(0.3),
            blurRadius: isHintSource ? 15 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 45),
        ),
      ),
    );

    if (isHintSource) {
      emojiBox = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          emojiBox,
          Positioned(
            right: -15,
            bottom: -15,
            child:
                const Icon(Icons.touch_app, size: 45, color: Colors.blueAccent)
                    .animate(onPlay: (controller) => controller.repeat())
                    .move(
                        begin: const Offset(10, 10),
                        end: const Offset(-5, -5),
                        duration: 800.ms,
                        curve: Curves.easeInOut)
                    .then()
                    .move(
                        begin: const Offset(-5, -5),
                        end: const Offset(10, 10),
                        duration: 800.ms,
                        curve: Curves.easeInOut),
          ),
        ],
      );
    }

    return Draggable<String>(
      data: emoji,
      feedback: Transform.scale(
        scale: 1.2,
        child: emojiBox,
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: emojiBox,
      ),
      child:
          emojiBox.animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildDragTargetWord(String correctEmoji) {
    bool isMatched = _matchedItems.contains(correctEmoji);
    String word = _allData[correctEmoji] ?? correctEmoji;

    bool isFirstMove =
        _currentLevel == 1 && _currentRound == 1 && _matchedItems.isEmpty;
    bool isHintTarget = isFirstMove && correctEmoji == _leftItems.first;

    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        bool isHovering = candidateData.isNotEmpty;

        Widget targetBox = AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 140,
          height: 60,
          decoration: BoxDecoration(
            color: isMatched
                ? AppTheme.success
                : (isHovering
                    ? AppTheme.secondaryColor.withOpacity(0.8)
                    : Colors.white),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isMatched
                  ? AppTheme.success
                  : (isHintTarget
                      ? Colors.blueAccent
                      : AppTheme.secondaryColor),
              width: isHintTarget ? 5 : 3,
            ),
            boxShadow: [
              if (!isMatched)
                BoxShadow(
                  color: isHintTarget
                      ? Colors.blueAccent.withOpacity(0.5)
                      : AppTheme.secondaryColor.withOpacity(0.2),
                  blurRadius: isHintTarget ? 15 : 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Center(
            child: Text(
              word,
              style: AppTextStyle.nunito(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isMatched
                    ? Colors.white
                    : (isHovering ? Colors.white : AppTheme.textPrimary),
              ),
            ),
          ),
        );

        if (isHintTarget && !isHovering && !isMatched) {
          targetBox = targetBox
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                  duration: 1500.ms, color: Colors.blueAccent.withOpacity(0.5));
        } else {
          targetBox = targetBox
              .animate(target: isMatched ? 1 : 0)
              .shimmer(duration: 500.ms, color: Colors.white);
        }

        return targetBox;
      },
      onWillAccept: (data) => data == correctEmoji && !isMatched,
      onAccept: (data) {
        _onMatchSuccess(data);
      },
    );
  }
}
