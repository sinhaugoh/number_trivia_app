import 'dart:math';

import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  NumberTriviaRemoteDataSourceImpt numberTriviaRemoteDataSourceImpt;
  
  setUp(() {
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDataSourceImpt = NumberTriviaRemoteDataSourceImpt(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((realInvocation) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((realInvocation) async =>
        http.Response('something went wrong', 404));
  }
  
  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should performs a GET request using the number and use header to get json',
          () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        numberTriviaRemoteDataSourceImpt.getConcreteNumberTrivia(tNumber);
        //assert
        verify(
          mockHttpClient.get(
            'http://numbersapi.com/$tNumber',
            headers: {
              'Content-Type': 'application/json',
            }
          )
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        final result = await numberTriviaRemoteDataSourceImpt.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        //arrange
        setUpMockHttpClientFailure404();
        //act
        final call = numberTriviaRemoteDataSourceImpt.getConcreteNumberTrivia;
        //assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should performs a GET request using the number and use header to get json',
          () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        numberTriviaRemoteDataSourceImpt.getRandomNumberTrivia();
        //assert
        verify(
            mockHttpClient.get(
                'http://numbersapi.com/random',
                headers: {
                  'Content-Type': 'application/json',
                }
            )
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200',
          () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        final result = await numberTriviaRemoteDataSourceImpt.getRandomNumberTrivia();
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        //arrange
        setUpMockHttpClientFailure404();
        //act
        final call = numberTriviaRemoteDataSourceImpt.getRandomNumberTrivia;
        //assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}