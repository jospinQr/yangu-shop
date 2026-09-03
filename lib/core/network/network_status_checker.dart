import 'package:bbo_shop_app/core/network/auth_header_interceptor.dart';
import 'package:bbo_shop_app/core/network/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkStatusCheckerProvider = Provider<NetworkStatusChecker>((ref) {
  return NetworkStatusChecker(ref.watch(dioProvider));
});

class NetworkStatusChecker {
  const NetworkStatusChecker(this._dio);

  final Dio _dio;

  Future<bool> hasInternetAccess() async {
    try {
      await _dio.get<Object>(
        '/greeting',
        options: Options(extra: const {skipAuthExtraKey: true}),
      );
      return true;
    } on DioException {
      return false;
    }
  }
}
