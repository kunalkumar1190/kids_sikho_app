import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';
import 'package:anganwadikids/core/widgets/common_app_bar.dart';
import 'video_player_page.dart';

class VideoItem {
  final String videoId;
  final String title;
  final String description;
  final Color primaryColor;
  final String emoji;
  final String category;

  const VideoItem({
    required this.videoId,
    required this.title,
    required this.description,
    required this.primaryColor,
    required this.emoji,
    required this.category,
  });
}

class VideosListPage extends StatelessWidget {
  const VideosListPage({super.key});

  final List<VideoItem> videos = const [
    VideoItem(
      videoId: 'hq3yfQnllfQ', // Phonics Song with TWO Words
      title: 'Phonics Song',
      description: 'Learn the ABCs with fun phonics!',
      primaryColor: Color(0xFFFFB74D),
      emoji: '🔤',
      category: 'Alphabet',
    ),
    VideoItem(
      videoId: 'D0Ajq682yrA', // Numbers Song Let's Count 1-10
      title: 'Numbers Song',
      description: 'Let us count from 1 to 10 together!',
      primaryColor: Color(0xFF64B5F6),
      emoji: '🔢',
      category: 'Numbers',
    ),
    VideoItem(
      videoId: 'tkpfg-1FJLU', // Shapes Song
      title: 'Shapes Song',
      description: 'Discover different shapes around us.',
      primaryColor: Color(0xFF5D5FEF),
      emoji: '⭐',
      category: 'Shapes',
    ),
    VideoItem(
      videoId: 'zXEq-QO3xTg', // Colors Song
      title: 'Colors Song',
      description: 'Red, yellow, green, and blue!',
      primaryColor: Color(0xFF81C784),
      emoji: '🎨',
      category: 'Colors',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: const CommonAppBar(
        title: "Fun Videos 📺",
        backgroundColor: Colors.transparent,
        isBottomSpace: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          
          if (isWide) {
            return GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 900 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
              ),
              itemCount: videos.length,
              itemBuilder: (context, index) => _buildVideoCard(context, videos[index]),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: videos.length,
            itemBuilder: (context, index) => _buildVideoCard(context, videos[index]),
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoItem video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: video.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KidsVideoPlayerPage(
                  videoId: video.videoId,
                  title: video.title,
                  description: video.description,
                  primaryColor: video.primaryColor,
                  emoji: video.emoji,
                  category: video.category,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: video.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      video.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: video.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          video.category,
                          style: TextStyle(
                            color: video.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        video.title,
                        style: AppTextStyle.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video.description,
                        style: AppTextStyle.nunito(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: video.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
