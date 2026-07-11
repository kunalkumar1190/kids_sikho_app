import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sikho_basic/core/theme/app_text_style.dart';

import '../../../core/services/audio_service.dart';
import '../bloc/animals_bloc.dart';
import '../bloc/animals_event.dart';
import '../bloc/animals_state.dart';

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({super.key});

  @override
  State<AnimalsPage> createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> {
  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  Future<void> _speakAnimal(String name) async {
    await _audioService.stop();
    _audioService.speak(name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnimalsBloc()..add(LoadAnimals()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: Text(
            "Learn Animals",
            style: AppTextStyle.fredoka(
              color: Colors.deepPurple,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.deepPurple),
        ),
        body: BlocBuilder<AnimalsBloc, AnimalsState>(
          builder: (context, state) {
            if (state is AnimalsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnimalsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is AnimalsLoaded) {
              final animalItems = state.animals;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  itemCount: animalItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final item = animalItems[index];

                    return GestureDetector(
                      onTap: () {
                        _speakAnimal(item.name);
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
                                ).animate()
                                 .scale(delay: (50 * index).ms, duration: 400.ms, curve: Curves.easeOutBack)
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
