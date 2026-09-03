import 'package:bbo_shop_app/core/security/auth_token_store.dart';
import 'package:dio/dio.dart';

const skipAuthExtraKey = 'skipAuth';

class AuthHeaderInterceptor extends Interceptor {
  AuthHeaderInterceptor(this._tokenStore);

  final AuthTokenStore _tokenStore;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthExtraKey] == true ||
        options.headers.containsKey('Authorization')) {
      handler.next(options);
      return;
    }

    try {
      final token = await _tokenStore.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } on Object {
      handler.next(options);
    }
  }
}
