import 'package:bbo_shop_app/core/network/dio_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkStatusCheckerProvider = Provider<NetworkStatusChecker>((ref) {
  return NetworkStatusChecker(
    ref.watch(connectivityProvider),
    ref.watch(dioProvider),
  );
});

class NetworkStatusChecker {
  const NetworkStatusChecker(this._connectivity, this._dio);

  final Connectivity _connectivity;
  final Dio _dio;

  Future<bool> hasInternetAccess() async {
    // final connectivityResults = await _connectivity.checkConnectivity();
    // final hasNetworkInterface = connectivityResults.any(
    //   (result) => result != ConnectivityResult.none,
    // );
    //
    // if (!hasNetworkInterface) {
    //   return false;
    // }

    try {
      await _dio.get<Object>('/greeting');
      return true;
    } on DioException {
      return false;
    }
  }
}
