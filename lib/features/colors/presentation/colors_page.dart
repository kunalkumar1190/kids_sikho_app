import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  final List<ColorItem> colorItems = const [
    ColorItem('Red', Colors.red),
    ColorItem('Blue', Colors.blue),
    ColorItem('Green', Colors.green),
    ColorItem('Yellow', Colors.yellow),
    ColorItem('Orange', Colors.orange),
    ColorItem('Purple', Colors.purple),
    ColorItem('Pink', Colors.pink),
    ColorItem('Brown', Colors.brown),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          "Learn Colors",
          style: GoogleFonts.fredoka(
            color: Colors.pink,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.pink),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          itemCount: colorItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final item = colorItems[index];

            return GestureDetector(
              onTap: () {
                // TODO: Play sound and navigate to detail page
              },
              child: Container(
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: item.color.withValues(alpha: 0.5),
                      offset: const Offset(0, 8),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: const Icon(
                        Icons.palette,
                        color: Colors.white54,
                        size: 30,
                      ).animate(onPlay: (controller) => controller.repeat())
                       .shimmer(duration: 2.seconds),
                    ),
                    Text(
                      item.name,
                      style: GoogleFonts.fredoka(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ).animate()
                     .scale(delay: (50 * index).ms, duration: 400.ms, curve: Curves.easeOutBack)
                     .then()
                     .shake(duration: 500.ms),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ColorItem {
  final String name;
  final Color color;

  const ColorItem(this.name, this.color);
}
