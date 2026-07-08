import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_sikho_app/core/widgets/question_lock_dialog.dart';
import '../bloc/drawing_bloc.dart';
import '../data/models/drawing_point.dart';

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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink.shade400,
                    Colors.purple.shade300,
                    Colors.blue.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade200.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    // Floating stars background animation
                    ...List.generate(8, (index) {
                      return Positioned(
                        top: 5 + index * 8.0,
                        left: 20 + index * 45.0,
                        child: TweenAnimationBuilder(
                          duration: Duration(milliseconds: 1200 + index * 200),
                          tween: Tween<double>(begin: 0.5, end: 1.0),
                          builder: (_, double value, __) {
                            return Opacity(
                              opacity: value,
                              child: Icon(
                                Icons.star,
                                color:
                                    Colors.white.withOpacity(0.3 + value * 0.3),
                                size: 12 + value * 6,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    // Title with bounce
                    Center(
                      child: AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + 0.03 * _bounceAnimation.value,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.brush,
                                    color: Colors.white, size: 28),
                                const SizedBox(width: 10),
                                Text(
                                  '🎨 Draw & Learn',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.brush,
                                    color: Colors.white, size: 28),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Lock button
                    Positioned(
                      right: 8,
                      top: 8,
                      child: AnimatedScale(
                        scale: _isLockEnabled ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: IconButton(
                          icon: Icon(
                            _isLockEnabled ? Icons.lock : Icons.lock_open,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: _toggleLock,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white
                                .withOpacity(_isLockEnabled ? 0.3 : 0.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    // Back button
                    Positioned(
                      left: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 26),
                        onPressed: () async {
                          if (!_isLockEnabled) {
                            Navigator.of(context).pop();
                          } else {
                            final unlocked =
                                await showParentLockDialog(context);
                            if (unlocked && context.mounted) {
                              setState(() => _isLockEnabled = false);
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.manual,
                                  overlays: SystemUiOverlay.values);
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade50,
                  Colors.purple.shade50,
                  Colors.blue.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const DrawingCanvas(),
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
              style: GoogleFonts.nunito(
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
              style: GoogleFonts.nunito(
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
    return Column(
      children: [
        // Canvas Area with animated border
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
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
                          // Animated sparkle overlay
                          if (state.points.isNotEmpty)
                            AnimatedBuilder(
                              animation: _sparkleAnimation,
                              builder: (context, child) {
                                return IgnorePointer(
                                  child: CustomPaint(
                                    painter: SparklePainter(
                                      points: state.points,
                                      animation: _sparkleAnimation.value,
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
        ),

        // Toolbar with attractive animations
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink.shade200,
                Colors.purple.shade200,
                Colors.blue.shade200,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.shade300.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Color Picker Button with glow
              _buildToolButton(
                icon: Icons.color_lens,
                color: Colors.blueAccent,
                onPressed: () => _pickColor(context),
                label: 'Color',
                glowColor: Colors.blueAccent.withOpacity(0.3),
              ),

              // Current Color Display with animated pulse
              BlocBuilder<DrawingBloc, DrawingState>(
                builder: (context, state) {
                  return TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 300),
                    tween: ColorTween(
                        begin: Colors.grey, end: state.selectedColor),
                    builder: (context, color, child) {
                      return Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (color ?? Colors.black).withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.circle,
                            color: Colors.white, size: 20),
                      );
                    },
                  );
                },
              ),

              // Undo Button
              _buildToolButton(
                icon: Icons.undo,
                color: Colors.orange,
                onPressed: () {
                  context.read<DrawingBloc>().add(UndoDrawing());
                },
                label: 'Undo',
                glowColor: Colors.orange.withOpacity(0.3),
              ),

              // Clear Button
              _buildToolButton(
                icon: Icons.delete_sweep,
                color: Colors.redAccent,
                onPressed: () {
                  context.read<DrawingBloc>().add(ClearDrawing());
                },
                label: 'Clear',
                glowColor: Colors.redAccent.withOpacity(0.3),
              ),
            ],
          ),
        ),

        // Fun message at bottom
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '🌈 Draw, Color, & Have Fun! 🎉',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.purple.shade400,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.purple.shade200.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String label,
    required Color glowColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.2),
              ],
              radius: 0.7,
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, size: 32, color: color),
            onPressed: onPressed,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
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

    final random = Random(42);
    final lastPoints = points.whereType<DrawingPoint>().toList();
    if (lastPoints.length < 3) return;

    // Draw sparkles near the last few points
    for (int i = max(0, lastPoints.length - 15); i < lastPoints.length; i++) {
      final point = lastPoints[i];
      if (point.offset == null) continue;

      final baseX = point.offset!.dx;
      final baseY = point.offset!.dy;

      // Each point gets 1-3 sparkles
      final count = 1 + (random.nextInt(3));
      for (int j = 0; j < count; j++) {
        final angle = random.nextDouble() * 2 * pi;
        final distance = 10 + animation * 20 + random.nextDouble() * 10;
        final x = baseX + cos(angle) * distance * (0.5 + animation * 0.5);
        final y = baseY + sin(angle) * distance * (0.5 + animation * 0.5);

        final size2 = 3 + animation * 6 + random.nextDouble() * 3;
        final color = Colors.primaries[random.nextInt(Colors.primaries.length)]
            .withOpacity(0.5 + animation * 0.3);

        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), size2, paint);

        // Draw star shape for some sparkles
        if (j % 2 == 0) {
          final starPaint = Paint()
            ..color = Colors.yellow.withOpacity(0.4 + animation * 0.3)
            ..style = PaintingStyle.fill;
          final path = Path();
          final starSize = size2 * 1.5;
          for (int k = 0; k < 10; k++) {
            final angle2 = k * 2 * pi / 10 - pi / 2;
            final radius = k.isEven ? starSize : starSize * 0.4;
            final px = x + cos(angle2) * radius;
            final py = y + sin(angle2) * radius;
            if (k == 0) {
              path.moveTo(px, py);
            } else {
              path.lineTo(px, py);
            }
          }
          path.close();
          canvas.drawPath(path, starPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
