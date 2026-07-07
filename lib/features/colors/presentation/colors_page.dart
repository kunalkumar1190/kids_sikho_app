import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/audio_service.dart';
import '../bloc/colors_bloc.dart';
import '../bloc/colors_event.dart';
import '../bloc/colors_state.dart';

class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  Future<void> _speakColor(String name) async {
    await _audioService.stop();
    _audioService.speak(name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ColorsBloc()..add(LoadColors()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: Text(
            "Learn Colors",
            style: GoogleFonts.fredoka(
              color: Colors.pink,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.pink),
        ),
        body: BlocBuilder<ColorsBloc, ColorsState>(
          builder: (context, state) {
            if (state is ColorsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ColorsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ColorsLoaded) {
              final colorItems = state.colors;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  itemCount: colorItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final item = colorItems[index];

                    return GestureDetector(
                      onTap: () {
                        _speakColor(item.name);
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
                            Positioned(
                              top: 10,
                              left: 10,
                              child: const Icon(
                                Icons.palette,
                                color: Colors.white54,
                                size: 30,
                              ).animate(onPlay: (controller) => controller.repeat())
                               .shimmer(duration: 2.seconds),
                            ),
                            Text(
                              item.name,
                              style: GoogleFonts.fredoka(
                                fontSize: 32,
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
                            ).animate()
                             .scale(delay: (50 * index).ms, duration: 400.ms, curve: Curves.easeOutBack)
                             .then()
                             .shake(duration: 500.ms),
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
