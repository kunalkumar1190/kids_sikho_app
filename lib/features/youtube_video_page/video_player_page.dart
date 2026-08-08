import 'package:flutter/material.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:anganwadikids/gen/assets.gen.dart';
import 'package:anganwadikids/core/widgets/common_app_bar.dart';

/// Colorful, Fun, Kid-Friendly Video Player Page
class KidsVideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String title;
  final String? description;
  final Color? primaryColor;
  final String? emoji;
  final bool autoPlay;
  final bool showStars;
  final String? category; // e.g., "ABC", "Numbers", "Fruits"
  final String captionLanguage;
  final bool enableCaption;

  const KidsVideoPlayerPage({
    Key? key,
    required this.videoId,
    required this.title,
    this.description,
    this.primaryColor,
    this.emoji,
    this.autoPlay = false,
    this.showStars = true,
    this.category,
    this.captionLanguage = 'en',
    this.enableCaption = false,
  }) : super(key: key);

  @override
  State<KidsVideoPlayerPage> createState() => _KidsVideoPlayerPageState();
}

class _KidsVideoPlayerPageState extends State<KidsVideoPlayerPage>
    with TickerProviderStateMixin {
  late YoutubePlayerController _videoController;
  bool _isMuted = false;
  bool _isLiked = false;
  int _starsCount = 0;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Color> _rainbowColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  final List<String> _funEmojis = [
    '🌟',
    '⭐',
    '🎉',
    '🎈',
    '🎊',
    '🌈',
    '🦄',
    '🐼'
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _setupAnimations();
  }

  void _setupAnimations() {
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initializeVideoPlayer() {
    _videoController = YoutubePlayerController(
      params: YoutubePlayerParams(
        showControls: false,
        mute: false,
        showFullscreenButton: false,
        loop: false,
        strictRelatedVideos: true,
        enableCaption: widget.enableCaption,
        captionLanguage: widget.captionLanguage,
      ),
    )..loadVideoById(videoId: widget.videoId);

    if (widget.autoPlay) {
      _videoController.playVideo();
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (_isMuted) {
        _videoController.mute();
      } else {
        _videoController.unMute();
      }
    });
  }

  void _addStar() {
    setState(() {
      _starsCount++;
      _bounceController.forward(from: 0);
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  void dispose() {
    _videoController.close();
    _bounceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              Assets.newautoimage.videoBg.path,
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                return Column(
                  children: [
                    CommonAppBar(
                      title: widget.title,
                      backgroundColor: Colors.transparent,
                      isBottomSpace: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 3, child: _buildVideoPlayer()),
                                Expanded(
                                    flex: 1, child: _buildContentSection()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildVideoPlayer(),
                                Expanded(child: _buildContentSection()),
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: Colors.black),
              AbsorbPointer(
                absorbing: true,
                child: YoutubePlayer(
                  controller: _videoController,
                ),
              ),
              YoutubeValueBuilder(
                controller: _videoController,
                builder: (context, value) {
                  // Show loading when not ready or unstarted or buffering
                  final isLoading = value.playerState == PlayerState.unknown ||
                      value.playerState == PlayerState.unStarted ||
                      value.playerState == PlayerState.buffering;

                  if (isLoading) {
                    return Positioned.fill(
                      child: Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Rating Row
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
              // Stars Rating Button
              if (widget.showStars)
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (ctx, child) {
                    return Transform.scale(
                      scale: _bounceAnimation.value,
                      child: GestureDetector(
                        onTap: _addStar,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade400,
                                Colors.amber.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_starsCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Category Badge
          if (widget.category != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: (widget.primaryColor ?? Colors.blue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (widget.primaryColor ?? Colors.blue).withOpacity(0.3),
                ),
              ),
              child: Text(
                '🎯 ${widget.category}',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.primaryColor ?? Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Description
          if (widget.description != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  const Text('📖', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Interactive Buttons Row
          Row(
            children: [
              // Play/Pause Button (Big, Fun)
              Expanded(
                child: YoutubeValueBuilder(
                  controller: _videoController,
                  builder: (context, value) {
                    final isPlaying = value.playerState == PlayerState.playing;
                    return _buildFunButton(
                      icon: isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      label: isPlaying ? 'Pause' : 'Play',
                      color: widget.primaryColor ?? Colors.blue,
                      onPressed: () {
                        if (isPlaying) {
                          _videoController.pauseVideo();
                        } else {
                          _videoController.playVideo();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Like Button
              Expanded(
                child: _buildFunButton(
                  icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                  label: 'Love',
                  color: _isLiked ? Colors.red : Colors.pink.shade100,
                  onPressed: _toggleLike,
                ),
              ),
              const SizedBox(width: 8),

              // Mute Button
              Expanded(
                child: _buildFunButton(
                  icon: _isMuted
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  label: _isMuted ? 'Unmute' : 'Mute',
                  color: _isMuted
                      ? Colors.grey
                      : (widget.primaryColor ?? Colors.blue),
                  onPressed: _toggleMute,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Fun Quote/Message
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.blue.shade50, width: 2),
            ),
            child: Row(
              children: [
                const Text('🌟', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getFunMessage(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
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

  Widget _buildFunButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFunMessage() {
    final messages = [
      "🌟 Learning is fun! Keep watching!",
      "🎉 You're doing great!",
      "🌈 Keep exploring and learning!",
      "⭐ You're a star student!",
      "🎈 Fun learning time!",
      "🦄 You're awesome!",
      "🐼 Keep smiling and learning!",
      "🚀 Ready for more learning?",
    ];
    return messages[_starsCount % messages.length];
  }
}
