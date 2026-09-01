import 'package:bbo_shop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppActionButton extends StatelessWidget {
  const AppActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = onPressed != null && !isLoading;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1, end: isLoading ? .98 : 1),
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            side: BorderSide(
              color: isEnabled ? AppColors.darkChocolate : AppColors.outline,
              width: 1,
            ),
          ),
          onPressed: isLoading ? null : onPressed,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: isLoading
                ? SizedBox.square(
                    key: const ValueKey('loader'),
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : DecoratedBox(
                    key: const ValueKey('icon'),
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? AppColors.amberCream
                          : AppColors.milkFoam,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Icon(
                        icon,
                        size: 17,
                        color: isEnabled
                            ? AppColors.darkChocolate
                            : AppColors.mutedText,
                      ),
                    ),
                  ),
          ),
          label: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: Text(label, key: ValueKey(label)),
          ),
        ),
      ),
    );
  }
}

class AppSecondaryActionButton extends StatelessWidget {
  const AppSecondaryActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.milkFoam.withValues(alpha: .54),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
