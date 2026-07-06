import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/audio_service.dart';
import '../bloc/numbers_bloc.dart';
import '../bloc/numbers_event.dart';
import '../bloc/numbers_state.dart';

class NumbersPage extends StatefulWidget {
  const NumbersPage({super.key});

  @override
  State<NumbersPage> createState() => _NumbersPageState();
}

class _NumbersPageState extends State<NumbersPage> {
  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  Future<void> _speakNumber(String number, String spelling) async {
    await _audioService.stop();
    String spelledOut = spelling.toUpperCase().split('').join(' ');
    _audioService.speak("$number, $spelledOut");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NumbersBloc()..add(LoadNumbers()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: Text(
            "Learn Numbers",
            style: GoogleFonts.fredoka(
              color: const Color(0xFF4ECDC4),
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF4ECDC4)),
        ),
        body: BlocBuilder<NumbersBloc, NumbersState>(
          builder: (context, state) {
            if (state is NumbersLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF4ECDC4)),
              );
            } else if (state is NumbersError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (state is NumbersLoaded) {
              final numbers = state.numbers;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: numbers.length,
                  itemExtent: 200,
                  itemBuilder: (context, index) {
                    final item = numbers[index];
                    final colors = [
                      Colors.red.shade300,
                      Colors.orange.shade300,
                      Colors.green.shade300,
                      Colors.blue.shade300,
                      Colors.purple.shade300,
                      Colors.pink.shade300,
                    ];
                    final color = colors[index % colors.length];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _speakNumber(item.number, item.spelling);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
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
                                    item.number,
                                    style: GoogleFonts.fredoka(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        const Shadow(
                                          color: Colors.black26,
                                          offset: Offset(2, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item.spelling,
                                    style: GoogleFonts.fredoka(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      shadows: [
                                        const Shadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                                  .animate()
                                  .scale(
                                    delay: (50 * (index % 10))
                                        .ms, // stagger slightly for visibility
                                    duration: 400.ms,
                                    curve: Curves.easeOutBack,
                                  )
                                  .then()
                                  .shake(duration: 500.ms),
                              Positioned(
                                bottom: 20,
                                right: 20,
                                child: const Icon(
                                  Icons.volume_up_rounded,
                                  color: Colors.white70,
                                  size: 40,
                                )
                                    .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(reverse: true))
                                    .shimmer(duration: 2.seconds),
                              )
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
