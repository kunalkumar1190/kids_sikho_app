import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';

import '../../../core/services/audio_service.dart';
import '../bloc/shapes_bloc.dart';
import '../bloc/shapes_event.dart';
import '../bloc/shapes_state.dart';
import 'package:anganwadikids/core/widgets/common_app_bar.dart';

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
        appBar: CommonAppBar(
          title: "Shapes",
          backgroundColor: Colors.lightBlue,
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
                      const Color(0xFFFFD54F), // Soft Yellow
                      const Color(0xFF81D4FA), // Sky Blue
                      const Color(0xFFA5D6A7), // Mint Green
                      const Color(0xFFFFAB91), // Peach
                      const Color(0xFFCE93D8), // Lavender
                      const Color(0xFFFFCCBC), // Light Orange
                      const Color(0xFFB39DDB), // Light Purple
                      const Color(0xFF80CBC4), // Aqua
                      const Color(0xFFF48FB1), // Pink
                      const Color(0xFFC5E1A5), // Lime
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
                                  style: AppTextStyle.nunito(
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
