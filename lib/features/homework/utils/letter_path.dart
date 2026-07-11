import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:seekho_basic/core/theme/app_text_style.dart';

class TracingMask {
  final Set<int> inkPixels; // Stores flattened index: y * width + x
  final int width;
  final int height;

  TracingMask({
    required this.inkPixels,
    required this.width,
    required this.height,
  });

  bool hitTest(Offset point, {double tolerance = 18.0}) {
    int px = point.dx.toInt();
    int py = point.dy.toInt();

    int t = tolerance.toInt();
    for (int y = py - t; y <= py + t; y++) {
      for (int x = px - t; x <= px + t; x++) {
        if (x >= 0 && x < width && y >= 0 && y < height) {
          int index = y * width + x;
          if (inkPixels.contains(index)) {
            // Check true distance
            int distSq = (x - px) * (x - px) + (y - py) * (y - py);
            if (distSq <= tolerance * tolerance) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }
}

class LetterPathUtil {
  /// Generates a pixel mask from text
  static Future<TracingMask> createTextMask(String text, Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromLTWH(0, 0, size.width, size.height));

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyle.nunito(
          fontSize: size.height * 0.8,
          fontWeight: FontWeight.w900,
          color: Colors.black, // Opaque color for mask
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    // Perfectly center the text
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);

    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    Set<int> inkPixels = {};
    if (byteData != null) {
      for (int i = 0; i < byteData.lengthInBytes; i += 4) {
        // rgba, check alpha channel
        if (byteData.getUint8(i + 3) > 10) {
          int pixelIndex = i ~/ 4;
          inkPixels.add(pixelIndex);
        }
      }
    }

    return TracingMask(
      inkPixels: inkPixels,
      width: size.width.toInt(),
      height: size.height.toInt(),
    );
  }
}
