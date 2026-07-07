abstract class AlphabetState {}

class AlphabetInitial extends AlphabetState {}

class AlphabetLoading extends AlphabetState {}

class AlphabetLoaded extends AlphabetState {
  final List<dynamic> alphabetData;
  AlphabetLoaded(this.alphabetData);
}

class AlphabetError extends AlphabetState {
  final String message;
  AlphabetError(this.message);
}
