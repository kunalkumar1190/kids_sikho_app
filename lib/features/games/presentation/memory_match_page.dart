import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/services/audio_service.dart';

class MemoryMatchPage extends StatefulWidget {
  const MemoryMatchPage({super.key});

  @override
  State<MemoryMatchPage> createState() => _MemoryMatchPageState();
}

class _MemoryMatchPageState extends State<MemoryMatchPage> {
  final List<String> _emojiChoices = ["🐶", "🐱", "🐰", "🦊", "🐻", "🐼", "🦁", "🐸"];
  late List<String> _cards;
  late List<bool> _isFlipped;
  late List<bool> _isMatched;
  
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
    _isFlipped = List<bool>.filled(16, false);
    _isMatched = List<bool>.filled(16, false);
    _previousIndex = null;
    _isProcessing = false;
    _score = 0;
    setState(() {});
  }

  void _onCardTap(int index) async {
    if (_isProcessing || _isFlipped[index] || _isMatched[index]) {
      return;
    }

    setState(() {
      _isFlipped[index] = true;
    });
    
    AudioService().speak(_cards[index]);

    if (_previousIndex == null) {
      _previousIndex = index;
    } else {
      _isProcessing = true;
      if (_cards[index] == _cards[_previousIndex!]) {
        // Match found
        setState(() {
          _isMatched[index] = true;
          _isMatched[_previousIndex!] = true;
          _score += 1;
        });
        _previousIndex = null;
        _isProcessing = false;
        
        if (_score == 8) {
          _showWinDialog();
        }
      } else {
        // No match
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        setState(() {
          _isFlipped[index] = false;
          _isFlipped[_previousIndex!] = false;
        });
        _previousIndex = null;
        _isProcessing = false;
      }
    }
  }

  void _showWinDialog() {
    AudioService().speak("You win! Great job!");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("You Win! 🎉"),
          content: const Text("Great job matching all the animals!"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Text(
          "Memory Match",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Matches: $_score / 8",
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: 16,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: _isFlipped[index] || _isMatched[index] 
                            ? Colors.white 
                            : Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _isFlipped[index] || _isMatched[index] ? _cards[index] : "?",
                          style: TextStyle(
                            fontSize: _isFlipped[index] || _isMatched[index] ? 40 : 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate(target: _isFlipped[index] ? 1 : 0).flip(duration: 300.ms),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
