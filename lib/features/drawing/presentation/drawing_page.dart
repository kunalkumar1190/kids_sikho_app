import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:anganwadikids/core/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';
import 'package:anganwadikids/core/widgets/question_lock_dialog.dart';
import '../bloc/drawing_bloc.dart';
import '../data/models/drawing_point.dart';
import 'package:anganwadikids/gen/assets.gen.dart';

// ============================================================================
// MAIN DRAWING PAGE WITH KID-FRIENDLY ANIMATIONS & ATTRACTIVE UI
// ============================================================================

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage>
    with SingleTickerProviderStateMixin {
  bool _isLockEnabled = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void _toggleLock() async {
    if (_isLockEnabled) {
      final unlocked = await showParentLockDialog(context);
      if (unlocked) {
        setState(() => _isLockEnabled = false);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('🔓 Parent lock disabled.'),
              backgroundColor: Colors.green[300],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          );
        }
      }
    } else {
      setState(() => _isLockEnabled = true);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🔒 Parent lock enabled.'),
            backgroundColor: Colors.orange[300],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawingBloc(),
      child: PopScope(
        canPop: !_isLockEnabled,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final unlocked = await showParentLockDialog(context);
          if (unlocked && context.mounted) {
            setState(() => _isLockEnabled = false);
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values);
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CommonAppBar(
            title: "Draw & Learn",
            backgroundColor: Colors.transparent,
            isBottomSpace: false,
            actions: [
              IconButton(
                icon: Icon(
                  _isLockEnabled ? Icons.lock : Icons.lock_open,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _toggleLock,
                style: IconButton.styleFrom(
                  backgroundColor:
                      Colors.pink.withOpacity(_isLockEnabled ? 0.8 : 0.8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          body: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  Assets.icons.backgroundImage.path,
                  fit: BoxFit.cover,
                ),
              ),

              // Foreground Content
              SafeArea(
                child: Column(
                  children: const [
                    Expanded(
                      child: DrawingCanvas(),
                    ),
                  ],
                ),
              ),

              // Positioned(
              //   left: -60,
              //   right: -60,
              //   bottom: -100,
              //   child: IgnorePointer(
              //     child: SafeArea(
              //       top: false,
              //       child: Image.asset(
              //         Assets.icons.bottomimage.path,
              //         fit: BoxFit.fitWidth,
              //         alignment: Alignment.bottomCenter,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DRAWING CANVAS WITH ATTRACTIVE ANIMATIONS FOR KIDS
// ============================================================================

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({Key? key}) : super(key: key);

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _sparkleController;
  late Animation<double> _sparkleAnimation;
  bool _hasShownIntro = false;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _sparkleAnimation = CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.elasticOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasShownIntro) {
        _hasShownIntro = true;
        _playIntroAnimation();
      }
    });
  }

  void _playIntroAnimation() async {
    // Wait a brief moment before starting
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2 - 40;
    final radius = 90.0;

    final bloc = context.read<DrawingBloc>();

    final paint = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // 1. Draw face outline (circle)
    for (int i = 0; i <= 40; i++) {
      if (!mounted) return;
      double t = i / 40.0;
      double angle = t * 2 * math.pi;
      double x = centerX + radius * math.cos(angle);
      double y = centerY + radius * math.sin(angle);

      bloc.add(AddDrawingPoint(DrawingPoint(
        offset: Offset(x, y),
        paint: paint,
      )));

      await Future.delayed(const Duration(milliseconds: 30));
    }
    bloc.add(EndDrawingStroke());

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // 2. Add left eye
    bloc.add(AddDrawingPoint(DrawingPoint(
      offset: Offset(centerX - 35, centerY - 25),
      paint: paint,
    )));
    bloc.add(EndDrawingStroke());

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // 3. Add right eye
    bloc.add(AddDrawingPoint(DrawingPoint(
      offset: Offset(centerX + 35, centerY - 25),
      paint: paint,
    )));
    bloc.add(EndDrawingStroke());

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // 4. Draw smile (arc)
    final smileRadius = 50.0;
    for (int i = 0; i <= 20; i++) {
      if (!mounted) return;
      double t = i / 20.0;
      // angle from pi/8 (22.5 deg) to 7pi/8 (157.5 deg)
      double angle = (math.pi * 0.15) + (t * (math.pi * 0.7));
      double x = centerX + smileRadius * math.cos(angle);
      double y = centerY + 10 + smileRadius * math.sin(angle);

      bloc.add(AddDrawingPoint(DrawingPoint(
        offset: Offset(x, y),
        paint: paint,
      )));

      await Future.delayed(const Duration(milliseconds: 30));
    }
    bloc.add(EndDrawingStroke());

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      bloc.add(ClearDrawing());
    }
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    super.dispose();
  }

  void _pickColor(BuildContext context) {
    final bloc = context.read<DrawingBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Row(
          children: [
            const Icon(Icons.color_lens, color: Colors.blueAccent, size: 30),
            const SizedBox(width: 10),
            Text(
              '🎨 Pick a Color!',
              style: AppTextStyle.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.pink.shade400,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: bloc.state.selectedColor,
            onColorChanged: (color) {
              bloc.add(ChangeColor(color));
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade400,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: Text(
              'Got it! ✨',
              style: AppTextStyle.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    final canvasArea = Expanded(
      child: Padding(
        padding: isLargeScreen
            ? const EdgeInsets.fromLTRB(25, 25, 0, 25)
            : const EdgeInsets.symmetric(horizontal: 25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFF8F0FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.shade200.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.purple.shade200.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.pink.shade100.withOpacity(0.5),
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BlocBuilder<DrawingBloc, DrawingState>(
              builder: (context, state) {
                return GestureDetector(
                  onPanUpdate: (details) {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final localPosition =
                        renderBox.globalToLocal(details.globalPosition);
                    context.read<DrawingBloc>().add(
                          AddDrawingPoint(
                            DrawingPoint(
                              offset: localPosition,
                              paint: Paint()
                                ..color = state.selectedColor
                                ..strokeWidth = state.strokeWidth
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true,
                            ),
                          ),
                        );
                  },
                  onPanEnd: (details) {
                    context.read<DrawingBloc>().add(EndDrawingStroke());
                  },
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: DrawingPainter(points: state.points),
                        child: Container(),
                      ),
                      // Animated cursor overlay using image
                      if (state.points.isNotEmpty &&
                          state.points.whereType<DrawingPoint>().isNotEmpty)
                        AnimatedBuilder(
                          animation: _sparkleAnimation,
                          builder: (context, child) {
                            final lastPoints =
                                state.points.whereType<DrawingPoint>().toList();
                            if (lastPoints.isEmpty)
                              return const SizedBox.shrink();
                            final lastPoint = lastPoints.last;
                            if (lastPoint.offset == null)
                              return const SizedBox.shrink();

                            final offset = lastPoint.offset!;

                            // Scale animation for pulsing effect
                            final scale = 1.0 + _sparkleAnimation.value * 0.15;

                            return Positioned(
                              // Adjust so the bottom-left or center aligns with the drawing point
                              left: offset.dx,
                              top: offset.dy - 50,
                              child: IgnorePointer(
                                child: Transform.scale(
                                  scale: scale,
                                  child: Image.asset(
                                    Assets.icons.starpaint.path,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    final toolsArea = _buildToolsArea(isLargeScreen);

    if (isLargeScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          canvasArea,
          toolsArea,
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          canvasArea,
          toolsArea,
          const SizedBox(height: 60),
        ],
      );
    }
  }

  Widget _buildToolsArea(bool isLargeScreen) {
    final children = [
      _toolItem(
        image: Assets.icons.drawingColor.path,
        onTap: () => _pickColor(context),
      ),
      BlocBuilder<DrawingBloc, DrawingState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: state.selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: state.selectedColor.withOpacity(.45),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.brush_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Pen",
                style: AppTextStyle.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ],
          );
        },
      ),
      _toolItem(
        image: Assets.icons.backundo.path,
        onTap: () {
          context.read<DrawingBloc>().add(UndoDrawing());
        },
      ),
      _toolItem(
        image: Assets.icons.clean.path,
        onTap: () {
          context.read<DrawingBloc>().add(ClearDrawing());
        },
      ),
    ];

    if (isLargeScreen) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 25, 25, 25),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.82),
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(.18),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children,
        ),
      );
    } else {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(34),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(.18),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      );
    }
  }

  Widget _toolItem({
    required String image,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            fit: BoxFit.contain,
            width: 70,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DRAWING PAINTER
// ============================================================================

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.offset!,
          points[i + 1]!.offset!,
          points[i]!.paint!,
        );
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [points[i]!.offset!],
          points[i]!.paint!,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================================
// SPARKLE PAINTER FOR KID-FRIENDLY ANIMATION
// ============================================================================

class SparklePainter extends CustomPainter {
  final List<DrawingPoint?> points;
  final double animation;

  SparklePainter({required this.points, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final lastPoints = points.whereType<DrawingPoint>().toList();
    if (lastPoints.isEmpty) return;

    final lastPoint = lastPoints.last;
    if (lastPoint.offset == null) return;

    final x = lastPoint.offset!.dx;
    final y = lastPoint.offset!.dy;

    // Draw a fun, pulsating star cursor that attracts kids
    final textSpan = TextSpan(
      text: '✏️',
      style: TextStyle(
        fontSize: 35 + animation * 8, // Pulsating effect
        shadows: [],
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Center the star exactly on the drawing point
    final offset =
        Offset(x - textPainter.width / 2, y - textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
