import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded({@required this.numberTrivia}): super([numberTrivia]);
}

class Error extends NumberTriviaState {
  final String errorMessage;

  Error({@required this.errorMessage}): super([errorMessage]);
}