import 'package:bbo_shop_app/core/widgets/app_action_button.dart';
import 'package:bbo_shop_app/core/widgets/app_animated_entrance.dart';
import 'package:flutter/material.dart';

class ConnectivityRetryPage extends StatelessWidget {
  const ConnectivityRetryPage({
    required this.onRetry,
    this.isRetrying = false,
    super.key,
  });

  final VoidCallback onRetry;
  final bool isRetrying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AppAnimatedEntrance(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: .92, end: 1),
                      duration: const Duration(milliseconds: 650),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Connexion indisponible',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Vérifiez votre connexion Internet puis réessayez.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: .72,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppActionButton(
                      label: 'Actualiser',
                      icon: Icons.refresh_rounded,
                      onPressed: isRetrying ? null : onRetry,
                      isLoading: isRetrying,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
