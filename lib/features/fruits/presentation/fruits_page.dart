import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';

import '../../../core/services/audio_service.dart';
import '../bloc/fruits_bloc.dart';
import '../bloc/fruits_event.dart';
import '../bloc/fruits_state.dart';

class FruitsPage extends StatefulWidget {
  const FruitsPage({super.key});

  @override
  State<FruitsPage> createState() => _FruitsPageState();
}

class _FruitsPageState extends State<FruitsPage> {
  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  Future<void> _speakFruit(String name) async {
    await _audioService.stop();
    _audioService.speak(name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FruitsBloc()..add(LoadFruits()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: Text(
            "Learn Fruits",
            style: AppTextStyle.fredoka(
              color: Colors.red,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.red),
        ),
        body: BlocBuilder<FruitsBloc, FruitsState>(
          builder: (context, state) {
            if (state is FruitsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FruitsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is FruitsLoaded) {
              final fruitItems = state.fruits;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  itemCount: fruitItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final item = fruitItems[index];

                    return GestureDetector(
                      onTap: () {
                        _speakFruit(item.name);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: item.color.withValues(alpha: 0.5),
                              offset: const Offset(0, 8),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.emoji,
                                  style: const TextStyle(fontSize: 60),
                                )
                                    .animate()
                                    .scale(
                                        delay: (50 * index).ms,
                                        duration: 400.ms,
                                        curve: Curves.easeOutBack)
                                    .then()
                                    .shake(duration: 500.ms),
                                const SizedBox(height: 10),
                                Text(
                                  item.name,
                                  style: AppTextStyle.fredoka(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      const Shadow(
                                        color: Colors.black26,
                                        offset: Offset(1, 2),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ).animate().fade(delay: (200 + 50 * index).ms),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
