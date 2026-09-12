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
  const MainPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  bool _dismissAutoPromptWhenLoginDialogCloses = false;

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
    final isRestoringSession = authState.isRestoringSession;
    final currentIndex = widget.navigationShell.currentIndex;
    _showLoginPromptIfNeeded(
      isAuthenticated: isAuthenticated,
      isRestoringSession: isRestoringSession,
      navigationState: navigationState,
    );

    return Stack(
      children: [
        Scaffold(
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
                  if (index == 3 && !isAuthenticated && !isRestoringSession) {
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
        ),
        _LoginDialogOverlay(
          isVisible: navigationState.isLoginSheetOpen,
          onClose: _closeLoginDialog,
          child: LoginBottomSheet(
            onClose: _closeLoginDialog,
            onOtpRequested: (phoneNumber) {
              _closeLoginDialog(requestedPhoneNumber: phoneNumber);
            },
          ),
        ),
      ],
    );
  }

  void _showLoginPromptIfNeeded({
    required bool isAuthenticated,
    required bool isRestoringSession,
    required MainNavigationState navigationState,
  }) {
    if (isAuthenticated ||
        isRestoringSession ||
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

  void _openLoginSheet({bool markAutoPromptAsDismissed = false}) {
    final navigationController = ref.read(
      mainNavigationControllerProvider.notifier,
    );
    final canOpen = navigationController.markLoginSheetOpen();
    if (!canOpen) {
      return;
    }

    _dismissAutoPromptWhenLoginDialogCloses = markAutoPromptAsDismissed;
  }

  void _closeLoginDialog({String? requestedPhoneNumber}) {
    if (!mounted) {
      return;
    }

    final navigationController = ref.read(
      mainNavigationControllerProvider.notifier,
    );
    navigationController.markLoginSheetClosed(
      dismissAutoPrompt: _dismissAutoPromptWhenLoginDialogCloses,
    );
    _dismissAutoPromptWhenLoginDialogCloses = false;

    if (requestedPhoneNumber != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        context.pushNamed(
          AppRouteNames.otp,
          queryParameters: {'phoneNumber': requestedPhoneNumber},
        );
      });
    }
  }
}

class _LoginDialogOverlay extends StatelessWidget {
  const _LoginDialogOverlay({
    required this.isVisible,
    required this.onClose,
    required this.child,
  });

  final bool isVisible;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !isVisible,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: .96,
                  end: 1,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
          child: isVisible
              ? _LoginDialogSurface(
                  key: const ValueKey('login-dialog-visible'),
                  onClose: onClose,
                  child: child,
                )
              : const SizedBox.shrink(key: ValueKey('login-dialog-hidden')),
        ),
      ),
    );
  }
}

class _LoginDialogSurface extends StatelessWidget {
  const _LoginDialogSurface({
    required this.onClose,
    required this.child,
    super.key,
  });

  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
              child: ColoredBox(
                color: AppColors.darkChocolate.withValues(alpha: .36),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Material(
                    color: AppColors.sand,
                    elevation: 18,
                    shadowColor: AppColors.darkChocolate.withValues(alpha: .24),
                    borderRadius: BorderRadius.circular(28),
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
