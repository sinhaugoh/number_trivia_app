import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main () {
  NetworkInfoImp networkInfoImp;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImp = NetworkInfoImp(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
        'should return a call to DataConnectionChecker.hasconnection',
        () async {
          //arrange
          when(mockDataConnectionChecker.hasConnection)
              .thenAnswer((_) async => true);
          //act
          final result = await networkInfoImp.isConnected;
          //assert
          verify(mockDataConnectionChecker.hasConnection);
          expect(result, true);
        },
    );
  });
}