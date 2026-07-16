import 'package:flutter/material.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/settings/settings_cubit.dart';
import '../../../core/widgets/language_toggle.dart';
import '../../../core/widgets/question_lock_dialog.dart';
import '../bloc/homework_bloc.dart';
import '../bloc/homework_event.dart';
import '../bloc/homework_state.dart';
import '../data/models/homework_item.dart';
import '../utils/letter_path.dart';
import '../utils/accuracy_calculator.dart';
import '../controllers/drawing_controller.dart';
import 'tracing_painter.dart';
import 'hint_animation.dart';

class TracingPage extends StatefulWidget {
  const TracingPage({super.key});

  @override
  State<TracingPage> createState() => _TracingPageState();
}

class _TracingPageState extends State<TracingPage>
    with TickerProviderStateMixin {
  final DrawingController _drawingController = DrawingController();

  late AnimationController _confettiController;
  late AnimationController _pulseController;

  bool _showHint = true;
  bool _isPreparing = false;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _drawingController.addListener(_onDrawingUpdate);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    _drawingController.removeListener(_onDrawingUpdate);
    _drawingController.dispose();
    super.dispose();
  }

  void _onDrawingUpdate() {
    setState(() {}); // Rebuild to reflect drawing changes
  }

  void _askQuestion(HomeworkItem item) {
    final isHindi = context.read<SettingsCubit>().state;
    final targetName = isHindi ? item.nameHi : item.nameEn;
    final question = isHindi ? "$targetName लिखो" : "Trace $targetName";
    AudioService().speak(question, languageCode: isHindi ? 'hi-IN' : 'en-US');
  }

  Future<void> _prepareMask(HomeworkItem item, Size size) async {
    TracingMask mask = await LetterPathUtil.createTextMask(item.symbol, size);

    if (mounted) {
      _drawingController.setMask(mask);
      setState(() {
        _showHint = true;
        _isPreparing = false;
      });
    }
  }

  void _checkDrawing(HomeworkItem currentItem) {
    if (!_drawingController.isReady || _drawingController.strokes.isEmpty) {
      _showMessage("Draw something first! 🎨", Colors.orange);
      return;
    }

    AccuracyResult result = AccuracyCalculator.calculate(
      totalInkPixels: _drawingController.mask!.inkPixels.length,
      hitPixels: _drawingController.hitPixels,
      validPoints: _drawingController.validPointsCount,
      invalidPoints: _drawingController.invalidPointsCount,
    );

    context.read<HomeworkBloc>().add(CheckHomeworkEvent(result: result));
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyle.nunito(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildStars(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          index < stars ? Icons.star_rounded : Icons.star_outline_rounded,
          color: index < stars ? Colors.orange : Colors.grey.shade400,
          size: 60,
        )
            .animate(delay: Duration(milliseconds: index * 200))
            .scale(duration: 400.ms, curve: Curves.elasticOut);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF), // Soft pastel blue background
      appBar: AppBar(
        title: Text(
          "Homework",
          style: AppTextStyle.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        actions: const [
          LanguageToggleWidget(),
          SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<HomeworkBloc, HomeworkState>(
        listener: (context, state) async {
          if (state is HomeworkLoaded) {
            _drawingController.clearMask();
            _askQuestion(state.currentItem);
          } else if (state is HomeworkSuccess) {
            _confettiController.forward(from: 0);
            AudioService().speak(state.result.message, languageCode: 'en-US');

            // Show Success Dialog
            final homeworkBloc = context.read<HomeworkBloc>();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStars(state.result.stars),
                    const SizedBox(height: 20),
                    Text(
                      "${state.result.percentage.toInt()}% Accuracy",
                      style:
                          AppTextStyle.nunito(fontSize: 20, color: Colors.grey),
                    ),
                    Text(
                      state.result.message,
                      style: AppTextStyle.fredoka(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: state.result.color,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        homeworkBloc.add(NextHomeworkEvent());
                      },
                      child: Text("Next!",
                          style: AppTextStyle.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    )
                  ],
                ),
              ),
            );
          } else if (state is HomeworkFail) {
            HapticFeedback.heavyImpact();
            AudioService().speak(state.result.message, languageCode: 'en-US');
            _showMessage(state.result.message, Colors.redAccent);
            _drawingController.clear();
          }
        },
        builder: (context, state) {
          if (state is HomeworkInitial || state is HomeworkLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.blueAccent),
                  const SizedBox(height: 20),
                  Text(
                    "Loading Tracing Guide...",
                    style: AppTextStyle.nunito(
                        fontSize: 18, color: Colors.blueAccent),
                  ),
                ],
              ),
            );
          } else if (state is HomeworkError) {
            return Center(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<HomeworkBloc>().add(LoadHomeworkEvent()),
                child: const Text("Retry"),
              ),
            );
          }

          HomeworkItem? currentItem;
          bool isSuccess = false;

          if (state is HomeworkLoaded) currentItem = state.currentItem;
          if (state is HomeworkFail) currentItem = state.currentItem;
          if (state is HomeworkSuccess) {
            currentItem = state.currentItem;
            isSuccess = true;
          }

          if (currentItem == null) return const SizedBox();

          return Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade100, Colors.blue.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_up,
                          color: Colors.blueAccent, size: 32),
                      onPressed: () => _askQuestion(currentItem!),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Trace: ",
                      style: AppTextStyle.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    Text(
                      currentItem!.symbol,
                      style: AppTextStyle.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),

              // Canvas
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  final size =
                      Size(constraints.maxWidth, constraints.maxHeight);

                  // Generate mask lazily when size is known
                  if (!_drawingController.isReady) {
                    if (!_isPreparing) {
                      _isPreparing = true;
                      _prepareMask(currentItem!, size);
                    }
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Container(
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100,
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: Colors.blue.shade200, width: 4),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Dotted Background
                          CustomPaint(
                            size: size,
                            painter: HintTextPainter(text: currentItem!.symbol),
                          ),

                          // 2. Hint Animation
                          if (_showHint)
                            HintAnimation(
                              size: size,
                              onComplete: () {
                                if (mounted) {
                                  setState(() => _showHint = false);
                                }
                              },
                            ),

                          // 3. User Drawing Interaction
                          GestureDetector(
                            onPanUpdate: (details) {
                              if (isSuccess || _showHint) return;
                              _drawingController
                                  .addPoint(details.localPosition);
                            },
                            onPanEnd: (details) {
                              if (isSuccess || _showHint) return;
                              _drawingController.endStroke();
                            },
                            child: Container(
                              color: Colors.transparent, // Capture gestures
                              child: CustomPaint(
                                size: size,
                                painter: TracingPainter(
                                    strokes: _drawingController.strokes),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              // Footer Controls
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Clear Button (Circular)
                    ElevatedButton(
                      onPressed: isSuccess
                          ? null
                          : () {
                              _drawingController.clear();
                              _showMessage("Board cleared! ✨", Colors.orange);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.refresh, size: 28),
                    ),
                    const SizedBox(width: 12),
                    // Next/Skip Button (With Text)
                    ElevatedButton.icon(
                      onPressed: isSuccess
                          ? null
                          : () async {
                              final unlocked = await showParentLockDialog(
                                  context,
                                  mode: LockMode.child);
                              if (unlocked == true && context.mounted) {
                                context
                                    .read<HomeworkBloc>()
                                    .add(NextHomeworkEvent());
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.skip_next, size: 24),
                      label: const Text("Next",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    // Check Button (Expanded)
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + 0.03 * _pulseController.value,
                            child: ElevatedButton.icon(
                              onPressed: isSuccess
                                  ? null
                                  : () => _checkDrawing(currentItem!),
                              icon: const Icon(Icons.check_circle, size: 28),
                              label: Text(
                                isSuccess ? "✅ Done!" : "Check!",
                                style: AppTextStyle.nunito(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSuccess
                                    ? Colors.green.shade400
                                    : Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
