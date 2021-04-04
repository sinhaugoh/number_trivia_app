import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //Bloc
  sl.registerFactory(() =>
      NumberTriviaBloc(
        getRandomNumberTrivia: sl(),
        getConcreteNumberTrivia: sl(),
        inputConverter: sl(),
      ));

  //use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //repository
  sl.registerLazySingleton<NumberTriviaRepository>(
          () =>
          NumberTriviaRepositoryImpl(
            localDataSource: sl(),
            networkInfo: sl(),
            remoteDataSource: sl(),
          ));

  //data sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
        () =>
        NumberTriviaLocalDataSourceImpl(
          sharedPreferences: sl(),
        ),);
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
        () =>
        NumberTriviaRemoteDataSourceImpt(
          client: sl(),
        ),);

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(sl(),));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
