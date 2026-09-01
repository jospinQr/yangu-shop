import 'package:bbo_shop_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: YanguShopApp()));
}

class YanguShopApp extends StatelessWidget {
  const YanguShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: YanguShopApp());
  }
}
