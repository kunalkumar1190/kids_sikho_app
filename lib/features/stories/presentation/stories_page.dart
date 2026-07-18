import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../bloc/stories_bloc.dart';
import '../data/models/story_model.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';
import '../../../core/settings/settings_cubit.dart';
import '../../../core/widgets/language_toggle.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoriesBloc()..add(LoadStories()),
      child: const StoriesView(),
    );
  }
}

class StoriesView extends StatefulWidget {
  const StoriesView({Key? key}) : super(key: key);

  @override
  State<StoriesView> createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: Text(
          'Magical Stories',
          style: AppTextStyle.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isGridView ? Icons.view_carousel : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          const LanguageToggleWidget(),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<StoriesBloc, StoriesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }
          if (state.error.isNotEmpty) {
            return Center(child: Text('Error: ${state.error}'));
          }
          if (state.stories.isEmpty) {
            return const Center(child: Text('No Stories Found'));
          }

          return isGridView
              ? GridView.builder(
                  padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 80.0), // Padding for bottom bar
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: state.stories.length,
                  itemBuilder: (context, index) {
                    return StoryGridItem(story: state.stories[index]);
                  },
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0, bottom: 80.0),
                  child: CardSwiper(
                    cardsCount: state.stories.length,
                    cardBuilder:
                        (context, index, percentThresholdX, percentThresholdY) {
                      return StoryCard(story: state.stories[index]);
                    },
                  ),
                );
        },
      ),
      bottomSheet: BlocBuilder<StoriesBloc, StoriesState>(
        builder: (context, state) {
          if (state.currentStory == null ||
              state.ttsState == TtsState.stopped) {
            return const SizedBox.shrink();
          }
          return StoryPlayerBottomBar(
              story: state.currentStory!, ttsState: state.ttsState);
        },
      ),
    );
  }
}

class StoryGridItem extends StatelessWidget {
  final StoryModel story;

  const StoryGridItem({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, bool>(
      builder: (context, isHindi) {
        bool isEnglish = !isHindi;
        return BlocBuilder<StoriesBloc, StoriesState>(
          builder: (context, state) {
            bool isPlayingThis = state.currentStory?.id == story.id &&
                state.ttsState == TtsState.playing;

            return GestureDetector(
              onTap: () {
                if (isPlayingThis) {
                  context.read<StoriesBloc>().add(StopStoryEvent());
                } else {
                  context.read<StoriesBloc>().add(
                        PlayStoryEvent(
                          textToSpeak:
                              isEnglish ? story.contentEn : story.contentHi,
                          languageCode: isEnglish ? 'en-US' : 'hi-IN',
                          story: story,
                        ),
                      );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (story.imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Image.asset(
                                story.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                  child: Icon(Icons.image_not_supported,
                                      size: 40, color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.indigoAccent,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.menu_book,
                                    size: 40, color: Colors.white),
                              ),
                            ),
                          Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              radius: 24,
                              child: Icon(
                                isPlayingThis
                                    ? Icons.stop_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            isEnglish ? story.titleEn : story.titleHi,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
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
      },
    );
  }
}

class StoryCard extends StatelessWidget {
  final StoryModel story;

  const StoryCard({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, bool>(
      builder: (context, isHindi) {
        bool isEnglish = !isHindi;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              if (story.imageUrl.isNotEmpty) ...[
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    child: Image.asset(
                      story.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                )
              ] else ...[
                Text(
                  isEnglish ? story.titleEn : story.titleHi,
                  style: AppTextStyle.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              isEnglish ? story.titleEn : story.titleHi,
                              style: AppTextStyle.nunito(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            isEnglish ? story.contentEn : story.contentHi,
                            style: AppTextStyle.nunito(
                              fontSize: 20,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<StoriesBloc, StoriesState>(
                        builder: (context, state) {
                          bool isPlaying = state.ttsState == TtsState.playing;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton.extended(
                                heroTag: 'play_btn_${story.id}',
                                backgroundColor: isPlaying
                                    ? Colors.redAccent
                                    : Colors.greenAccent[400],
                                icon: Icon(
                                  isPlaying
                                      ? Icons.stop_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 30,
                                ),
                                label: Text(
                                  isPlaying ? 'Stop' : 'Listen',
                                  style: AppTextStyle.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  if (isPlaying) {
                                    context.read<StoriesBloc>().add(
                                          StopStoryEvent(),
                                        );
                                  } else {
                                    context.read<StoriesBloc>().add(
                                          PlayStoryEvent(
                                            textToSpeak: isEnglish
                                                ? story.contentEn
                                                : story.contentHi,
                                            languageCode:
                                                isEnglish ? 'en-US' : 'hi-IN',
                                            story: story,
                                          ),
                                        );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StoryPlayerBottomBar extends StatelessWidget {
  final StoryModel story;
  final TtsState ttsState;

  const StoryPlayerBottomBar({
    Key? key,
    required this.story,
    required this.ttsState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = ttsState == TtsState.playing;

    return BlocBuilder<SettingsCubit, bool>(
      builder: (context, isHindi) {
        bool isEnglish = !isHindi;
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              if (story.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    story.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 40),
                  ),
                )
              else
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_book, color: Colors.white),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isEnglish ? story.titleEn : story.titleHi,
                      style: AppTextStyle.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      isPlaying ? 'Playing...' : 'Paused',
                      style: AppTextStyle.nunito(
                        fontSize: 14,
                        color: Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.greenAccent[400],
                  size: 48,
                ),
                onPressed: () {
                  if (isPlaying) {
                    context.read<StoriesBloc>().add(PauseStoryEvent());
                  } else {
                    context.read<StoriesBloc>().add(
                          PlayStoryEvent(
                            textToSpeak:
                                isEnglish ? story.contentEn : story.contentHi,
                            languageCode: isEnglish ? 'en-US' : 'hi-IN',
                            story: story,
                          ),
                        );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop_circle,
                    color: Colors.redAccent, size: 48),
                onPressed: () {
                  context.read<StoriesBloc>().add(StopStoryEvent());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
