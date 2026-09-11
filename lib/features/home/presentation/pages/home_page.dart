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
        slivers: [
          SliverToBoxAdapter(
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
                                            homeCategoryControllerProvider
                                                .notifier,
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
                const SizedBox(height: 24),
              ],
            ),
          ),
          SliverList.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              return HomeProductSectionList(
                key: ValueKey(sections[index].id),
                section: sections[index],
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
