import 'package:bbo_shop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeChoiceChip extends StatelessWidget {
  const HomeChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1, end: isSelected ? 1.04 : 1),
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        showCheckmark: false,
        onSelected: (_) => onSelected(),
        backgroundColor: AppColors.warmCream,
        selectedColor: AppColors.chocolate,
        side: BorderSide(
          color: isSelected
              ? AppColors.darkChocolate
              : AppColors.cocoa.withValues(alpha: .28),
          width: isSelected ? .8 : .6,
        ),
        elevation: isSelected ? 2 : 0,
        pressElevation: 1,
        shadowColor: AppColors.darkChocolate.withValues(alpha: .16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          color: isSelected ? AppColors.warmCream : AppColors.darkChocolate,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
          letterSpacing: 0,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
