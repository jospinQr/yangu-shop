import 'package:bbo_shop_app/features/home/presentation/controllers/home_category_controller.dart';
import 'package:bbo_shop_app/features/home/presentation/controllers/home_feed_provider.dart';
import 'package:bbo_shop_app/features/home/presentation/widgets/home_choice_chip.dart';
import 'package:bbo_shop_app/features/home/presentation/widgets/home_product_section_list.dart';
import 'package:bbo_shop_app/features/home/presentation/widgets/search_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(homeCategoryControllerProvider);
    final sections = ref.watch(homeFeedSectionsProvider);

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: _HomeHeader(
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                ref
                    .read(homeCategoryControllerProvider.notifier)
                    .select(category);
              },
            ),
          ),
          SliverList.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              return _AnimatedHomeSection(
                key: ValueKey(sections[index].id),
                position: index,
                child: HomeProductSectionList(section: sections[index]),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final HomeCategory selectedCategory;
  final ValueChanged<HomeCategory> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final child = Column(
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
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final category in HomeCategory.values) ...[
                          HomeChoiceChip(
                            label: category.label,
                            isSelected: selectedCategory == category,
                            onSelected: () => onCategorySelected(category),
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
        const SizedBox(height: 24),
      ],
    );

    if (reduceMotion) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _AnimatedHomeSection extends StatelessWidget {
  const _AnimatedHomeSection({
    required this.position,
    required this.child,
    super.key,
  });

  final int position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return child;
    }

    final duration = Duration(
      milliseconds: 220 + (position.clamp(0, 3).toInt() * 35),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
