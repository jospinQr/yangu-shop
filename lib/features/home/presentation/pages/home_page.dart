import 'package:bbo_shop_app/core/widgets/app_animated_entrance.dart';
import 'package:bbo_shop_app/features/home/presentation/controllers/home_category_controller.dart';
import 'package:bbo_shop_app/features/home/presentation/widgets/home_choice_chip.dart';
import 'package:bbo_shop_app/features/home/presentation/widgets/search_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(homeCategoryControllerProvider);

    return SafeArea(
      child: Column(
        children: [
          const SearchButton(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 42,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final category in HomeCategory.values) ...[
                            HomeChoiceChip(
                              label: category.label,
                              isSelected: selectedCategory == category,
                              onSelected: () {
                                ref
                                    .read(
                                      homeCategoryControllerProvider.notifier,
                                    )
                                    .select(category);
                              },
                            ),
                            if (category != HomeCategory.values.last)
                              const SizedBox(width: 10),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: AppAnimatedEntrance(
              child: Center(
                child: Text(
                  'Home',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
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
