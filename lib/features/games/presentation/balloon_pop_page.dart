import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:seekho_basic/core/theme/app_text_style.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/services/audio_service.dart';

class Balloon {
  final int id;
  final Color color;
  final double x;
  double y;

  Balloon(
      {required this.id,
      required this.color,
      required this.x,
      required this.y});
}

class BalloonPopPage extends StatefulWidget {
  const BalloonPopPage({super.key});

  @override
  State<BalloonPopPage> createState() => _BalloonPopPageState();
}

class _BalloonPopPageState extends State<BalloonPopPage> {
  final List<Balloon> _balloons = [];
  Timer? _gameLoopTimer;
  Timer? _spawnTimer;
  int _score = 0;
  int _balloonIdCounter = 0;
  final Random _random = Random();

  final List<Color> _balloonColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGame();
    });
  }

  void _startGame() {
    _score = 0;
    _balloons.clear();

    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      setState(() {
        for (var balloon in _balloons) {
          balloon.y -= 5; // move up
        }
        _balloons.removeWhere((b) => b.y < -150);
      });
    });

    _spawnTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) return;
      _spawnBalloon();
    });
  }

  void _spawnBalloon() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final x = _random.nextDouble() * (screenWidth - 100);
    final color = _balloonColors[_random.nextInt(_balloonColors.length)];

    setState(() {
      _balloons.add(Balloon(
        id: _balloonIdCounter++,
        color: color,
        x: x,
        y: screenHeight,
      ));
    });
  }

  void _popBalloon(Balloon balloon) {
    setState(() {
      if (_balloons.remove(balloon)) {
        _score += 1;
        AudioService().speak("Pop");
      }
    });
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: Text(
          "Balloon Pop",
          style: AppTextStyle.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue.shade100, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Score
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3)),
                ],
              ),
              child: Text(
                "Score: $_score",
                style: AppTextStyle.fredoka(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ),

          // Balloons
          ..._balloons
              .map((b) => Positioned(
                    key: ValueKey(b.id),
                    left: b.x,
                    top: b.y,
                    child: GestureDetector(
                      onTap: () => _popBalloon(b),
                      child: Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(
                            color: b.color,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(40),
                              bottom: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: b.color.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5))
                            ]),
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text("🎈", style: TextStyle(fontSize: 50)),
                          ),
                        ),
                      )
                          .animate()
                          .scale(duration: 200.ms, curve: Curves.easeOutBack),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
