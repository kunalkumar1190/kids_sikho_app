import 'package:flutter/material.dart';
import '../utils/letter_path.dart';
import '../../drawing/data/models/drawing_point.dart';

class DrawingController extends ChangeNotifier {
  TracingMask? _currentMask;
  List<DrawingPoint?> strokes = [];
  Set<int> _hitPixels = {};
  
  int validPointsCount = 0;
  int invalidPointsCount = 0;
  
  bool get isReady => _currentMask != null;
  TracingMask? get mask => _currentMask;
  
  void setMask(TracingMask mask) {
    _currentMask = mask;
    strokes.clear();
    _hitPixels.clear();
    notifyListeners();
  }
  
  void clearMask() {
    _currentMask = null;
    strokes.clear();
    _hitPixels.clear();
    validPointsCount = 0;
    invalidPointsCount = 0;
    notifyListeners();
  }

  void addPoint(Offset point) {
    if (_currentMask == null) return;

    // Check hit test against mask
    bool hit = _currentMask!.hitTest(point, tolerance: 18.0);
    
    if (hit) {
      // It's a valid point, color it green
      strokes.add(DrawingPoint(
        offset: point,
        paint: Paint()
          ..color = Colors.green
          ..strokeWidth = 24.0
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true,
      ));
      
      // Record hit pixels for accuracy (simulate stroke width covering pixels)
      int px = point.dx.toInt();
      int py = point.dy.toInt();
      int t = 16; // Simulate radius of stroke
      
      validPointsCount++;
      
      for (int y = py - t; y <= py + t; y++) {
        for (int x = px - t; x <= px + t; x++) {
          if (x >= 0 && x < _currentMask!.width && y >= 0 && y < _currentMask!.height) {
            int index = y * _currentMask!.width + x;
            if (_currentMask!.inkPixels.contains(index)) {
              _hitPixels.add(index);
            }
          }
        }
      }
    } else {
      invalidPointsCount++;
      // It's invalid, color it red
      strokes.add(DrawingPoint(
        offset: point,
        paint: Paint()
          ..color = Colors.redAccent.withValues(alpha: 0.5)
          ..strokeWidth = 24.0
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true,
      ));
    }
    notifyListeners();
  }

  void endStroke() {
    strokes.add(null);
    notifyListeners();
  }
  
  void clear() {
    strokes.clear();
    _hitPixels.clear();
    validPointsCount = 0;
    invalidPointsCount = 0;
    notifyListeners();
  }

  Set<int> get hitPixels => _hitPixels;
}
