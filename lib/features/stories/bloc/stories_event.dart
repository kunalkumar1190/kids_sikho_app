part of 'stories_bloc.dart';

abstract class StoriesEvent {
  const StoriesEvent();
}

class LoadStories extends StoriesEvent {}

class PlayStoryEvent extends StoriesEvent {
  final String textToSpeak;
  final String languageCode;

  const PlayStoryEvent({required this.textToSpeak, required this.languageCode});
}

class PauseStoryEvent extends StoriesEvent {}
class StopStoryEvent extends StoriesEvent {}
