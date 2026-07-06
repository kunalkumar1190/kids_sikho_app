part of 'stories_bloc.dart';

enum TtsState { stopped, playing, paused }

class StoriesState extends Equatable {
  final List<StoryModel> stories;
  final bool isLoading;
  final String error;
  final TtsState ttsState;

  const StoriesState({
    this.stories = const [],
    this.isLoading = false,
    this.error = '',
    this.ttsState = TtsState.stopped,
  });

  StoriesState copyWith({
    List<StoryModel>? stories,
    bool? isLoading,
    String? error,
    TtsState? ttsState,
  }) {
    return StoriesState(
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      ttsState: ttsState ?? this.ttsState,
    );
  }

  @override
  List<Object> get props => [stories, isLoading, error, ttsState];
}
