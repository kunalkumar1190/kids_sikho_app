import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({super.key});

  final List<AnimalItem> animalItems = const [
    AnimalItem('Dog', '🐶', Colors.brown),
    AnimalItem('Cat', '🐱', Colors.orange),
    AnimalItem('Lion', '🦁', Colors.amber),
    AnimalItem('Monkey', '🐒', Colors.brown),
    AnimalItem('Elephant', '🐘', Colors.blueGrey),
    AnimalItem('Tiger', '🐯', Colors.deepOrange),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          "Learn Animals",
          style: GoogleFonts.fredoka(
            color: Colors.deepPurple,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          itemCount: animalItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final item = animalItems[index];

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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.emoji,
                          style: const TextStyle(fontSize: 60),
                        ).animate()
                         .scale(delay: (50 * index).ms, duration: 400.ms, curve: Curves.easeOutBack)
                         .then()
                         .shake(duration: 500.ms),
                        const SizedBox(height: 10),
                        Text(
                          item.name,
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              const Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ).animate().fade(delay: (200 + 50 * index).ms),
                      ],
                    ),
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

class AnimalItem {
  final String name;
  final String emoji;
  final Color color;

  const AnimalItem(this.name, this.emoji, this.color);
}
