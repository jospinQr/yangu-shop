import 'package:bbo_shop_app/app/router/app_routes.dart';
import 'package:bbo_shop_app/core/theme/app_colors.dart';
import 'package:bbo_shop_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:bbo_shop_app/features/auth/presentation/widgets/login_bottom_sheet.dart';
import 'package:bbo_shop_app/features/main/presentation/controllers/main_navigation_controller.dart';
import 'package:bbo_shop_app/features/main/presentation/controllers/main_navigation_state.dart';
import 'package:bbo_shop_app/features/main/presentation/widgets/animated_nav_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(
      mainNavigationControllerProvider.select(
        (state) => state.loginSheetRequestCount,
      ),
      (previous, next) {
        if (previous != null && next > previous) {
          _openLoginSheet();
        }
      },
    );

    final authState = ref.watch(authControllerProvider);
    final navigationState = ref.watch(mainNavigationControllerProvider);
    final isAuthenticated = authState.isAuthenticated;
    final currentIndex = widget.navigationShell.currentIndex;
    _showLoginPromptIfNeeded(
      isAuthenticated: isAuthenticated,
      navigationState: navigationState,
    );

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.sand,
          border: Border(
            top: BorderSide(
              color: AppColors.cocoa.withValues(alpha: .24),
              width: .8,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkChocolate.withValues(alpha: .18),
              blurRadius: 22,
              spreadRadius: 2,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              widget.navigationShell.goBranch(
                index,
                initialLocation: index == currentIndex,
              );
              if (index == 3 && !isAuthenticated) {
                _openLoginSheet();
              }
            },
            destinations: [
              NavigationDestination(
                selectedIcon: AnimatedNavIcon(
                  icon: Icons.search_rounded,
                  isSelected: currentIndex == 0,
                ),
                icon: AnimatedNavIcon(
                  icon: Icons.search_outlined,
                  isSelected: currentIndex == 0,
                ),
                label: 'Explorer',
              ),
              NavigationDestination(
                selectedIcon: AnimatedNavIcon(
                  icon: Icons.shopping_bag_rounded,
                  isSelected: currentIndex == 1,
                ),
                icon: AnimatedNavIcon(
                  icon: Icons.shopping_bag_outlined,
                  isSelected: currentIndex == 1,
                ),
                label: 'Panier',
              ),
              NavigationDestination(
                selectedIcon: AnimatedNavIcon(
                  icon: Icons.storefront_rounded,
                  isSelected: currentIndex == 2,
                ),
                icon: AnimatedNavIcon(
                  icon: Icons.storefront_outlined,
                  isSelected: currentIndex == 2,
                ),
                label: 'Galerie',
              ),
              NavigationDestination(
                selectedIcon: AnimatedNavIcon(
                  icon: isAuthenticated
                      ? Icons.person_rounded
                      : Icons.login_rounded,
                  isSelected: currentIndex == 3,
                ),
                icon: AnimatedNavIcon(
                  icon: isAuthenticated
                      ? Icons.person_outline_rounded
                      : Icons.login,
                  isSelected: currentIndex == 3,
                ),
                label: isAuthenticated ? 'Profil' : 'Connexion',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoginPromptIfNeeded({
    required bool isAuthenticated,
    required MainNavigationState navigationState,
  }) {
    if (isAuthenticated ||
        navigationState.isAutoLoginPromptDismissed ||
        navigationState.isLoginSheetOpen) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final latestState = ref.read(mainNavigationControllerProvider);
      if (!mounted ||
          latestState.isAutoLoginPromptDismissed ||
          latestState.isLoginSheetOpen) {
        return;
      }
      _openLoginSheet(markAutoPromptAsDismissed: true);
    });
  }

  Future<void> _openLoginSheet({
    bool markAutoPromptAsDismissed = false,
  }) async {
    final navigationController = ref.read(
      mainNavigationControllerProvider.notifier,
    );
    final canOpen = navigationController.markLoginSheetOpen();
    if (!canOpen) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      backgroundColor: AppColors.sand,
      builder: (sheetContext) {
        return LoginBottomSheet(
          onOtpRequested: (phoneNumber) {
            context.pushNamed(
              AppRouteNames.otp,
              queryParameters: {'phoneNumber': phoneNumber},
            );
          },
        );
      },
    );

    if (!mounted) {
      return;
    }

    navigationController.markLoginSheetClosed(
      dismissAutoPrompt: markAutoPromptAsDismissed,
    );
  }
}
