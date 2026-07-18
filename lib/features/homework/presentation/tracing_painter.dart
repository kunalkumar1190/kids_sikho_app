import 'dart:ui' as ui;
import 'package:anganwadikids/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import '../../drawing/data/models/drawing_point.dart';

class TracingPainter extends CustomPainter {
  final List<DrawingPoint?> strokes;

  TracingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty) return;

    for (int i = 0; i < strokes.length - 1; i++) {
      if (strokes[i] != null && strokes[i + 1] != null) {
        canvas.drawLine(
          strokes[i]!.offset!,
          strokes[i + 1]!.offset!,
          strokes[i]!.paint!,
        );
      } else if (strokes[i] != null && strokes[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [strokes[i]!.offset!],
          strokes[i]!.paint!,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant TracingPainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}

class HintTextPainter extends CustomPainter {
  final String text;

  HintTextPainter({required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyle.nunito(
          fontSize: size.height * 0.8,
          fontWeight: FontWeight.w900,
          color: Colors.grey.withValues(alpha: 0.15),
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant HintTextPainter oldDelegate) {
    return oldDelegate.text != text;
  }
}
