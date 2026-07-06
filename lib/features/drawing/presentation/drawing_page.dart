import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/drawing_bloc.dart';
import '../data/models/drawing_point.dart';

class DrawingPage extends StatelessWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawingBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Draw & Learn',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.pinkAccent,
          centerTitle: true,
          elevation: 0,
        ),
        body: const DrawingCanvas(),
      ),
    );
  }
}

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({Key? key}) : super(key: key);

  void _pickColor(BuildContext context) {
    final bloc = context.read<DrawingBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
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
            child: const Text('Got it'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Canvas Area
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BlocBuilder<DrawingBloc, DrawingState>(
                builder: (context, state) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      final localPosition = renderBox.globalToLocal(details.globalPosition);
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
                    child: CustomPaint(
                      painter: DrawingPainter(points: state.points),
                      child: Container(), // Fills the available space
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.pink[50],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.color_lens, size: 36, color: Colors.blueAccent),
                onPressed: () => _pickColor(context),
              ),
              BlocBuilder<DrawingBloc, DrawingState>(
                builder: (context, state) {
                  return Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: state.selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.undo, size: 36, color: Colors.orangeAccent),
                onPressed: () {
                  context.read<DrawingBloc>().add(UndoDrawing());
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 36, color: Colors.redAccent),
                onPressed: () {
                  context.read<DrawingBloc>().add(ClearDrawing());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
        // Draw a single point if it's just a tap
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
