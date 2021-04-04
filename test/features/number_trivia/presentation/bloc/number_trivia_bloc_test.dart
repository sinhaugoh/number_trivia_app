import 'dart:math';

import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(getConcreteNumberTrivia: mockGetConcreteNumberTrivia, getRandomNumberTrivia: mockGetRandomNumberTrivia, inputConverter: mockInputConverter);
  });

  test(
    'initialState should be empty',
        () async {
      expect(bloc.initialState, equals(Empty()));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test text');

    void setUpMockInputConverterSuccess() => when(mockInputConverter.stringToUnsignedInt(any))
        .thenReturn(Right(tNumberParsed));

    test(
      'should call thhe InputConverter to validate and convert the string into unsigned integer',
          () async {
        //arrange
        setUpMockInputConverterSuccess();
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInt(any));
        //assert
        verify(mockInputConverter.stringToUnsignedInt(any));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
          () async {
        //arrange
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(Left(InvalidInputFailure()));
        //assert
        final expected = [
          Empty(),
          Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from thhe concrete use case',
      () async {
        //arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        //assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        //arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        //assert
        final expected = [
          Empty(),
          Loading(),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
          () async {
        //arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        //assert
        final expected = [
          Empty(),
          Loading(),
          Error(errorMessage: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
        //arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        //assert
        final expected = [
          Empty(),
          Loading(),
          Error(errorMessage: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMessage: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMessage  : CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });
}