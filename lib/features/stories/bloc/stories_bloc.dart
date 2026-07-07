import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/audio_service.dart';
import '../data/models/story_model.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final AudioService _audioService = AudioService();

  StoriesBloc() : super(const StoriesState()) {
    on<LoadStories>(_onLoadStories);
    on<PlayStoryEvent>(_onPlayStory);
    on<PauseStoryEvent>(_onPauseStory);
    on<StopStoryEvent>(_onStopStory);

    _audioService.setCompletionHandler(() {
      add(StopStoryEvent());
    });
  }

  Future<void> _onLoadStories(LoadStories event, Emitter<StoriesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final String response = await rootBundle.loadString('assets/data/stories.json');
      final data = await json.decode(response) as List;
      final List<StoryModel> stories = data.map((e) => StoryModel.fromJson(e)).toList();
      emit(state.copyWith(isLoading: false, stories: stories));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onPlayStory(PlayStoryEvent event, Emitter<StoriesState> emit) async {
    emit(state.copyWith(ttsState: TtsState.playing));
    await _audioService.speak(event.textToSpeak, languageCode: event.languageCode);
  }

  Future<void> _onPauseStory(PauseStoryEvent event, Emitter<StoriesState> emit) async {
    await _audioService.pause();
    emit(state.copyWith(ttsState: TtsState.paused));
  }

  Future<void> _onStopStory(StopStoryEvent event, Emitter<StoriesState> emit) async {
    await _audioService.stop();
    emit(state.copyWith(ttsState: TtsState.stopped));
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
