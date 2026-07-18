part of 'stories_bloc.dart';

enum TtsState { stopped, playing, paused }

class StoriesState {
  final List<StoryModel> stories;
  final bool isLoading;
  final String error;
  final TtsState ttsState;
  final StoryModel? currentStory;

  const StoriesState({
    this.stories = const [],
    this.isLoading = false,
    this.error = '',
    this.ttsState = TtsState.stopped,
    this.currentStory,
  });

  StoriesState copyWith({
    List<StoryModel>? stories,
    bool? isLoading,
    String? error,
    TtsState? ttsState,
    StoryModel? currentStory,
  }) {
    return StoriesState(
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      ttsState: ttsState ?? this.ttsState,
      currentStory: currentStory ?? this.currentStory,
    );
  }
}
