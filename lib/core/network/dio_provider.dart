import 'package:bbo_shop_app/core/config/app_config.dart';
import 'package:bbo_shop_app/core/network/auth_header_interceptor.dart';
import 'package:bbo_shop_app/core/security/auth_token_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 6),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    AuthHeaderInterceptor(ref.watch(authTokenStoreProvider)),
  );
  return dio;
});
