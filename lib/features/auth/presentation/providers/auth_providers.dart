import 'package:bbo_shop_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:bbo_shop_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
