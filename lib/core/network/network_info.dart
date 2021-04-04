import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImp implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  NetworkInfoImp(this.dataConnectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}