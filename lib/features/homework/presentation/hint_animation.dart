import 'package:flutter/material.dart';

class HintAnimation extends StatefulWidget {
  final Size size;
  final VoidCallback onComplete;

  const HintAnimation({
    super.key,
    required this.size,
    required this.onComplete,
  });

  @override
  State<HintAnimation> createState() => _HintAnimationState();
}

class _HintAnimationState extends State<HintAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          widget.onComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // A simple path tracing animation for the hint
        // Moving from top left to bottom right of the center bounds
        double dx = widget.size.width * 0.3 + (widget.size.width * 0.4 * _animation.value);
        double dy = widget.size.height * 0.2 + (widget.size.height * 0.6 * _animation.value);

        return Positioned(
          left: dx - 30, // center the 60px hand icon
          top: dy - 30,
          child: Opacity(
            opacity: _animation.value < 0.9 ? 1.0 : (1.0 - _animation.value) * 10,
            child: Icon(
              Icons.touch_app,
              size: 60,
              color: Colors.yellow.shade700,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
