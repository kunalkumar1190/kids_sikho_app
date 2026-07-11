import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seekho_basic/core/theme/app_text_style.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../../core/services/audio_service.dart';
import '../bloc/alphabet_bloc.dart';
import '../bloc/alphabet_event.dart';
import '../bloc/alphabet_state.dart';

class AlphabetPage extends StatefulWidget {
  const AlphabetPage({super.key});

  @override
  State<AlphabetPage> createState() => _AlphabetPageState();
}

class _AlphabetPageState extends State<AlphabetPage> {
  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  Future<void> _speakAlphabet(Map<String, dynamic> data) async {
    await _audioService.stop();
    await _audioService.speak("${data['letter']} for ${data['word']}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlphabetBloc()..add(LoadAlphabet()),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5E9),
        appBar: AppBar(
          title: Text(
            "Learn Alphabets",
            style: AppTextStyle.fredoka(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<AlphabetBloc, AlphabetState>(
          builder: (context, state) {
            if (state is AlphabetLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.green));
            } else if (state is AlphabetError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is AlphabetLoaded) {
              final alphabetData = state.alphabetData;
              if (alphabetData.isEmpty) {
                return const Center(child: Text("No data found"));
              }
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: CardSwiper(
                  cardsCount: alphabetData.length,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    if (currentIndex != null) {
                      _speakAlphabet(alphabetData[currentIndex]);
                    }
                    return true;
                  },
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) {
                    final item = alphabetData[index];
                    final colors = [
                      Colors.orange.shade300,
                      Colors.blue.shade300,
                      Colors.pink.shade300,
                      Colors.green.shade300,
                      Colors.purple.shade300,
                      Colors.red.shade300,
                    ];
                    final color = colors[index % colors.length];

                    return Center(
                      child: GestureDetector(
                        onTap: () => _speakAlphabet(item),
                        child: Container(
                          width: double.infinity,
                          height: 400,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                offset: const Offset(0, 10),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 3,
                                child: FittedBox(
                                  child: Text(
                                    item['emoji'],
                                    style: const TextStyle(
                                      fontSize: 100,
                                    ),
                                  )
                                      .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(reverse: true),
                                      )
                                      .scaleXY(
                                        begin: 1.0,
                                        end: 1.2,
                                        duration: 1.seconds,
                                        curve: Curves.easeInOut,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Flexible(
                                flex: 3,
                                child: FittedBox(
                                  child: Text(
                                    item['letter'],
                                    style: AppTextStyle.fredoka(
                                      fontSize: 100,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        const Shadow(
                                          color: Colors.black26,
                                          offset: Offset(4, 6),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ).animate().slideY(
                                        begin: 0.5,
                                        end: 0,
                                        duration: 500.ms,
                                        curve: Curves.easeOutBack,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Flexible(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      item['word'],
                                      style: AppTextStyle.fredoka(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        shadows: [
                                          const Shadow(
                                            color: Colors.black12,
                                            offset: Offset(2, 3),
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ).animate().fade(
                                      delay: 300.ms,
                                      duration: 400.ms,
                                    ),
                              ),
                            ],
                          ),
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
