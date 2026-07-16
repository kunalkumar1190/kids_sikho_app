import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';

import '../../../app/routes/app_router.dart';
import '../../home/widgets/glass_card.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          "Fun Games",
          style: AppTextStyle.fredoka(
            color: Colors.pinkAccent,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.pinkAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Choose a game to play!",
              style: AppTextStyle.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
                children: [
                  _buildGameCard(
                    context,
                    title: "Balloon Pop",
                    emoji: "🎈",
                    color: Colors.greenAccent,
                    route: Routes.balloonPop,
                  ),
                  _buildGameCard(
                    context,
                    title: "Memory Match",
                    emoji: "🧠",
                    color: Colors.blueAccent,
                    route: Routes.memoryMatch,
                  ),
                  _buildGameCard(
                    context,
                    title: "Listen & Find",
                    emoji: "🔍",
                    color: Colors.orangeAccent,
                    route: Routes.findIt,
                  ),
                  _buildGameCard(
                    context,
                    title: "Match It!",
                    emoji: "🔗",
                    color: Colors.purpleAccent,
                    route: Routes.matchFollowing,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String emoji,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: GlassCard(
                width: 150,
                borderRadius: 20,
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: AppTextStyle.fredoka(
                      fontSize: 18,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
