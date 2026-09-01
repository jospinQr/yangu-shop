import 'package:bbo_shop_app/core/network/network_status_checker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final startupCheckProvider = FutureProvider.autoDispose<bool>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 2500));
  return ref.watch(networkStatusCheckerProvider).hasInternetAccess();
});
