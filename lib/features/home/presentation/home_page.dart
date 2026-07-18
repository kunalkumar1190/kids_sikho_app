import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';
import 'package:anganwadikids/app/routes/app_router.dart';
import 'package:anganwadikids/features/home/widgets/glass_card.dart';
import 'package:anganwadikids/gen/assets.gen.dart';
import '../../../core/settings/settings_cubit.dart';
import '../../../core/widgets/language_toggle.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<HomeMenuItem> menus = [
    HomeMenuItem(
      title: "Alphabets",
      assetImage: Assets.icons.alphabet,
      emoji: "🔤",
      lightColor: const Color(0xFFFFE0B2),
      mainColor: const Color(0xFFFFB74D),
      textColor: const Color(0xFFF57C00),
      path: Routes.alphabet,
    ),
    HomeMenuItem(
      title: "Numbers",
      assetImage: Assets.icons.number,
      emoji: "🔢",
      lightColor: const Color(0xFFBBDEFB),
      mainColor: const Color(0xFF64B5F6),
      textColor: const Color(0xFF1976D2),
      path: Routes.numbers,
    ),
    HomeMenuItem(
      title: "Shapes",
      assetImage: Assets.icons.star,
      emoji: "⭐",
      lightColor: const Color(0xFFF0F4FF),
      mainColor: const Color(0xFF5D5FEF),
      textColor: const Color(0xFF3F3D56),
      path: Routes.shapes,
    ),
    HomeMenuItem(
      title: "Colors",
      emoji: "🎨",
      lightColor: const Color(0xFFC8E6C9),
      mainColor: const Color(0xFF81C784),
      textColor: const Color(0xFF388E3C),
      path: Routes.colors,
    ),
    HomeMenuItem(
      title: "Fruits",
      assetImage: Assets.icons.fruits,
      emoji: "🍎",
      lightColor: const Color(0xFFC8E6C9),
      mainColor: const Color(0xFF81C784),
      textColor: const Color(0xFF388E3C),
      path: Routes.fruits,
    ),
    HomeMenuItem(
      title: "Animals",
      assetImage: Assets.icons.animal,
      emoji: "🐘",
      lightColor: const Color(0xFFE1BEE7),
      mainColor: const Color(0xFFBA68C8),
      textColor: const Color(0xFF7B1FA2),
      path: Routes.animals,
    ),
    HomeMenuItem(
      title: "Stories",
      assetImage: Assets.icons.commonstory,
      emoji: "📖",
      lightColor: const Color(0xFFFFCDD2),
      mainColor: const Color(0xFFE57373),
      textColor: const Color(0xFFD32F2F),
      path: Routes.stories,
    ),
    // HomeMenuItem(
    //   title: "Songs",
    //   assetImage: Assets.icons.audio,
    //   emoji: "🎵",
    //   lightColor: const Color(0xFFFFF9C4),
    //   mainColor: const Color(0xFFFFD54F),
    //   textColor: const Color(0xFFF57F17),
    //   path: "",
    // ),
    HomeMenuItem(
      title: "Drawing",
      assetImage: Assets.icons.drawing,
      emoji: "🎨",
      lightColor: const Color(0xFFB2EBF2),
      mainColor: const Color(0xFF4DD0E1),
      textColor: const Color(0xFF0097A7),
      path: Routes.drawing,
    ),
    HomeMenuItem(
      title: "Games",
      assetImage: Assets.icons.quiz,
      emoji: "🏆",
      lightColor: const Color(0xFFF8BBD0),
      mainColor: const Color(0xFFF06292),
      textColor: const Color(0xFFC2185B),
      path: Routes.games,
    ),
    HomeMenuItem(
      title: "Homework",
      emoji: "✍️",
      lightColor: const Color(0xFFE8F5E9),
      mainColor: const Color(0xFF81C784),
      textColor: const Color(0xFF2E7D32),
      path: Routes.homework,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background - Sky and Hills
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8FD3FE), Color(0xFFE3F2FD)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: -100,
            right: -100,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF88D847),
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(
                    MediaQuery.of(context).size.width + 200,
                    150,
                  ),
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        _buildTopBar(context),
                        const SizedBox(height: 20),
                        _buildWelcomeBanner(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(35),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildGridMenu(context),
                        const SizedBox(height: 25),
                        _buildBottomBanners(context),
                        const SizedBox(
                          height: 100,
                        ), // Padding for bottom nav bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFFFFE0B2),
            child: Text("👦", style: TextStyle(fontSize: 30)),
          ),
        ),

        // Title
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Anganwadi ",
              style: AppTextStyle.fredoka(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF5252),
                shadows: [
                  const Shadow(
                    color: Colors.white,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            Text(
              "Kids",
              style: AppTextStyle.fredoka(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF448AFF),
                shadows: [
                  const Shadow(
                    color: Colors.white,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello Little Explorer! 👋",
                  style: AppTextStyle.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Let's learn something\nawesome today!",
                  style: AppTextStyle.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            Assets.icons.lion,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: menus.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width >= 800 ? 3 : 2,
        crossAxisSpacing: MediaQuery.of(context).size.width >= 800 ? 20 : 15,
        mainAxisSpacing: MediaQuery.of(context).size.width >= 800 ? 20 : 15,
        childAspectRatio:
            MediaQuery.of(context).size.width >= 1200 ? 0.85 : 0.9,
      ),
      itemBuilder: (context, index) {
        final screenWidth = MediaQuery.of(context).size.width;
        final item = menus[index];

        return InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            if (item.path.isNotEmpty) {
              context.push(item.path);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Coming Soon!")));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: item.mainColor,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: item.mainColor.withOpacity(0.4),
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
                    width: double.infinity,
                    borderRadius: 20,
                    child: Center(
                      child: item.assetImage != null
                          ? Image.asset(
                              item.assetImage!,
                              fit: BoxFit.contain,
                            )
                          : Text(
                              item.emoji ?? "✨",
                              style: TextStyle(
                                fontSize: screenWidth >= 800 ? 90 : 70,
                              ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: Text(
                        item.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.fredoka(
                          fontSize: screenWidth >= 800 ? 20 : 18,
                          color: item.textColor,
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
      },
    );
  }

  Widget _buildBottomBanners(BuildContext context) {
    return Row(children: [
      // Daily Goal
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E5F5), // Light purple
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFAB47BC), // Purple
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "Daily Goal",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("⭐", style: TextStyle(fontSize: 30)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Keep it up!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: 0.6,
                          backgroundColor: Colors.white,
                          color: Colors.green,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 15),
    ]);
  }
}

class HomeMenuItem {
  final String title;
  final String? assetImage;
  final String? emoji;
  final Color lightColor;
  final Color mainColor;
  final Color textColor;
  final String path;

  const HomeMenuItem({
    required this.title,
    this.assetImage,
    this.emoji,
    required this.lightColor,
    required this.mainColor,
    required this.textColor,
    required this.path,
  });
}
