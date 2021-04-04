import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]): super(props);
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString): super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}