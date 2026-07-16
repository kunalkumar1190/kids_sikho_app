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
      child: Scaffold(
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
          actions: const [
            LanguageToggleWidget(),
            SizedBox(width: 16),
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

            return Padding(
              padding: const EdgeInsets.all(16.0),
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
      ),
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
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  child: story.imageUrl.startsWith('http')
                      ? Image.network(
                          story.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey),
                          ),
                        )
                      : Image.asset(
                          story.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey),
                          ),
                        ),
                ),
              ),
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
