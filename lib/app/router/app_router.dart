import 'package:bbo_shop_app/app/router/app_routes.dart';
import 'package:bbo_shop_app/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:bbo_shop_app/features/cart/presentation/pages/cart_page.dart';
import 'package:bbo_shop_app/features/gallery/presentation/pages/gallery_page.dart';
import 'package:bbo_shop_app/features/home/presentation/pages/home_page.dart';
import 'package:bbo_shop_app/features/main/presentation/pages/main_page.dart';
import 'package:bbo_shop_app/features/profile/presentation/pages/profile_page.dart';
import 'package:bbo_shop_app/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 220),
            reverseTransitionDuration: const Duration(milliseconds: 160),
            child: MainPage(navigationShell: navigationShell),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  );

                  return FadeTransition(
                    opacity: curvedAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, .015),
                        end: Offset.zero,
                      ).animate(curvedAnimation),
                      child: child,
                    ),
                  );
                },
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRouteNames.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                name: AppRouteNames.cart,
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.gallery,
                name: AppRouteNames.gallery,
                builder: (context, state) => const GalleryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: AppRouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: AppRouteNames.otp,
        builder: (context, state) {
          final phoneNumber = state.uri.queryParameters['phoneNumber'] ?? '';
          return OtpVerificationPage(phoneNumber: phoneNumber);
        },
      ),
    ],
  );
});
