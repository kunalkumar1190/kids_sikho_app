import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seekho_basic/core/theme/app_text_style.dart';

import '../../../core/services/audio_service.dart';
import '../bloc/shapes_bloc.dart';
import '../bloc/shapes_event.dart';
import '../bloc/shapes_state.dart';

class ShapesPage extends StatefulWidget {
  const ShapesPage({super.key});

  @override
  State<ShapesPage> createState() => _ShapesPageState();
}

class _ShapesPageState extends State<ShapesPage> {
  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  Future<void> _speakShape(String shapeName) async {
    await _audioService.stop();
    String spelledOut = shapeName.toUpperCase();
    _audioService.speak(spelledOut);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShapesBloc()..add(LoadShapes()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        appBar: AppBar(
          title: Text(
            "Learn Shapes",
            style: AppTextStyle.fredoka(
              color: const Color(0xFF5D5FEF),
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF5D5FEF)),
        ),
        body: BlocBuilder<ShapesBloc, ShapesState>(
          builder: (context, state) {
            if (state is ShapesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF5D5FEF)),
              );
            } else if (state is ShapesError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (state is ShapesLoaded) {
              final shapes = state.shapes;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  itemCount: shapes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final item = shapes[index];
                    final colors = [
                      Colors.amber.shade400,
                      Colors.cyan.shade400,
                      Colors.deepPurple.shade400,
                      Colors.teal.shade400,
                      Colors.redAccent.shade400,
                      Colors.indigo.shade400,
                    ];
                    final color = colors[index % colors.length];

                    return GestureDetector(
                      onTap: () {
                        _speakShape(item.name);
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
                                  item.symbol,
                                  style: const TextStyle(fontSize: 70),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.name,
                                  style: AppTextStyle.fredoka(
                                    fontSize: 26,
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
                                  delay: (50 * index).ms, // stagger slightly
                                  duration: 400.ms,
                                  curve: Curves.easeOutBack,
                                )
                                .then()
                                .shake(duration: 500.ms),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: const Icon(
                                Icons.volume_up_rounded,
                                color: Colors.white70,
                                size: 30,
                              )
                                  .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(reverse: true))
                                  .shimmer(duration: 2.seconds),
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
