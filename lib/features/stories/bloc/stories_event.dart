part of 'stories_bloc.dart';

abstract class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object> get props => [];
}

class LoadStories extends StoriesEvent {}

class PlayStoryEvent extends StoriesEvent {
  final String textToSpeak;
  final String languageCode;

  const PlayStoryEvent({required this.textToSpeak, required this.languageCode});

  @override
  List<Object> get props => [textToSpeak, languageCode];
}

class PauseStoryEvent extends StoriesEvent {}
class StopStoryEvent extends StoriesEvent {}
