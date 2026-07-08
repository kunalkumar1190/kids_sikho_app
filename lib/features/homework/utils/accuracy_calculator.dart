import 'package:flutter/material.dart';

class AccuracyResult {
  final double percentage;
  final int stars;
  final String message;
  final Color color;

  AccuracyResult({
    required this.percentage,
    required this.stars,
    required this.message,
    required this.color,
  });
}

class AccuracyCalculator {
  static AccuracyResult calculate({
    required int totalInkPixels,
    required Set<int> hitPixels,
    required int validPoints,
    required int invalidPoints,
  }) {
    if (totalInkPixels == 0)
      return AccuracyResult(
          percentage: 0, stars: 0, message: "Try Again", color: Colors.red);
    if (validPoints + invalidPoints == 0)
      return AccuracyResult(
          percentage: 0,
          stars: 0,
          message: "Draw something!",
          color: Colors.orange);

    // 1. Coverage Score (How much of the ink did they trace?)
    double rawCoverage = hitPixels.length / totalInkPixels;
    // For text, the ink is a massive solid block of font, they only need to draw a line through it.
    double requiredCoverage = 0.35;
    double coverageScore = (rawCoverage / requiredCoverage) * 100;
    if (coverageScore > 100) coverageScore = 100;

    // 2. Precision Score (Did they stay on the path or scribble everywhere?)
    double precisionScore = (validPoints / (validPoints + invalidPoints)) * 100;

    // Final Score is a mix of both. They must cover the shape AND stay on the path.
    double finalScore = (coverageScore * 0.5) + (precisionScore * 0.5);

    int stars;
    String message;
    Color color;

    if (finalScore >= 85) {
      stars = 3;
      message = "Perfect! 🌟";
      color = Colors.orange;
    } else if (finalScore >= 70) {
      stars = 2;
      message = "Very Good! ✨";
      color = Colors.green;
    } else if (finalScore >= 50) {
      stars = 1;
      message = "Good! 👍";
      color = Colors.blue;
    } else {
      stars = 0;
      message = "Try Again 😊";
      color = Colors.red;
    }

    return AccuracyResult(
      percentage: finalScore,
      stars: stars,
      message: message,
      color: color,
    );
  }
}
