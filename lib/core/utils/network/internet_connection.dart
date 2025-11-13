import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfol {
  Future<bool> isConnected();

  Future<ConnectivityResult> get connectivityResult;

  Stream<ConnectivityResult> get onConnectivityChanged;
}

class NetworkInfo implements NetworkInfol {
  Connectivity connectivity;
  static final NetworkInfo _networkInfo = NetworkInfo._internal(Connectivity());

  factory NetworkInfo() {
    return _networkInfo;
  }

  NetworkInfo._internal(this.connectivity) {
    connectivity = connectivity;
  }

  @override
  Future<bool> isConnected() async {
    final results = await connectivity.checkConnectivity();
    return results.isNotEmpty && results.first != ConnectivityResult.none;
  }

  @override
  Future<ConnectivityResult> get connectivityResult async {
    final results = await connectivity.checkConnectivity();

    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map(
      (results) => results.isNotEmpty ? results.first : ConnectivityResult.none,
    );
  }
}

abstract class Failure {}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

///can be used for throwing [NoInternetException]
class NoInternetException implements Exception {
  late String _message;

  NoInternetException([String message = 'No Internet Connection']) {
    _message = message.isEmpty ? 'No Internet Connection' : message;
  }

  @override
  String toString() {
    return _message;
  }
}
