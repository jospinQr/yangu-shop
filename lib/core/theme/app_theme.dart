import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.chocolate,
      onPrimary: AppColors.warmCream,
      primaryContainer: AppColors.milkFoam,
      onPrimaryContainer: AppColors.darkChocolate,
      secondary: AppColors.caramel,
      onSecondary: AppColors.darkChocolate,
      secondaryContainer: AppColors.amberCream,
      onSecondaryContainer: AppColors.darkChocolate,
      tertiary: AppColors.tealInk,
      onTertiary: AppColors.warmCream,
      surface: AppColors.warmCream,
      onSurface: AppColors.charcoal,
      error: AppColors.danger,
      outline: AppColors.outline,
      outlineVariant: Color(0xFFE9D7BD),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.sand,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.sand,
        surfaceTintColor: AppColors.sand,
        modalBackgroundColor: AppColors.sand,
        showDragHandle: false,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.sand,
        foregroundColor: AppColors.charcoal,
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: AppColors.sand,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.warmCream,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIconColor: AppColors.mutedText,
        floatingLabelStyle: const TextStyle(
          color: AppColors.chocolate,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: const TextStyle(color: AppColors.mutedText),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline, width: .6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.chocolate, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: .8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          backgroundColor: AppColors.chocolate,
          foregroundColor: AppColors.warmCream,
          disabledBackgroundColor: AppColors.outline,
          disabledForegroundColor: AppColors.mutedText,
          elevation: 2,
          shadowColor: AppColors.darkChocolate.withValues(alpha: .30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          foregroundColor: AppColors.darkChocolate,
          side: const BorderSide(color: AppColors.cocoa),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.tealInk,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: AppColors.sand,
        indicatorColor: Colors.transparent,
        indicatorShape: const CircleBorder(),
        elevation: 8,
        shadowColor: AppColors.darkChocolate.withValues(alpha: .12),
        surfaceTintColor: AppColors.sand,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: isSelected ? 25 : 23,
            color: isSelected ? AppColors.chocolate : AppColors.mutedText,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            color: isSelected ? AppColors.chocolate : AppColors.mutedText,
            fontSize: isSelected ? 12.5 : 11.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            letterSpacing: 0,
          );
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.chocolate,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkChocolate,
        contentTextStyle: const TextStyle(color: AppColors.warmCream),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

extension ThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textStyles => Theme.of(this).textTheme;
}
