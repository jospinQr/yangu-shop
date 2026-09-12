import 'package:bbo_shop_app/app/router/app_routes.dart';
import 'package:bbo_shop_app/core/widgets/connectivity_retry_page.dart';
import 'package:bbo_shop_app/features/splash/presentation/controllers/startup_check_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingAnimationController;
  bool _hasNavigatedToHome = false;

  @override
  void initState() {
    super.initState();
    _loadingAnimationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(startupCheckProvider, (previous, next) {
      final canReachApi = next.asData?.value;
      if (canReachApi == true) {
        _goToHome();
      }
    });

    final startupCheck = ref.watch(startupCheckProvider);
    if (startupCheck.asData?.value == false || startupCheck.hasError) {
      return ConnectivityRetryPage(
        isRetrying: startupCheck.isLoading,
        onRetry: () => ref.invalidate(startupCheckProvider),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final logoSize = (constraints.maxWidth * 0.24)
                .clamp(84.0, 108.0)
                .toDouble();
            final animationSize = (constraints.maxWidth * 0.32)
                .clamp(112.0, 144.0)
                .toDouble();

            return Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Transform.translate(
                      offset: const Offset(0, -20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon/marquer.png',
                                  width: logoSize,
                                  height: logoSize,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 0.01),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'YanguShop',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            height: 1.05,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Luka. Zwa. Somba',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            height: 1.15,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Cherche. Trouve. Achete.',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            height: 1.15,
                                            color: theme.colorScheme.tertiary,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          RepaintBoundary(
                            child: Semantics(
                              label: 'Chargement de YanguShop',
                              liveRegion: true,
                              child: SizedBox.square(
                                dimension: animationSize,
                                child: Lottie.asset(
                                  'assets/lottie/logo.json',
                                  controller: _loadingAnimationController,
                                  repeat: false,
                                  fit: BoxFit.contain,
                                  onLoaded: _startLoadingAnimation,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 52,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Par Atelog', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _goToHome() {
    if (_hasNavigatedToHome || !mounted) {
      return;
    }

    _hasNavigatedToHome = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.goNamed(AppRouteNames.home);
    });
  }

  void _startLoadingAnimation(LottieComposition composition) {
    if (!mounted || _loadingAnimationController.isAnimating) {
      return;
    }

    _loadingAnimationController
      ..duration = composition.duration
      ..repeat();
  }
}
