import 'package:bbo_shop_app/core/theme/app_colors.dart';
import 'package:bbo_shop_app/features/home/presentation/controllers/home_feed_provider.dart';
import 'package:bbo_shop_app/features/home/presentation/widgets/list_product_item.dart';
import 'package:flutter/material.dart';

class HomeProductSectionList extends StatelessWidget {
  const HomeProductSectionList({required this.section, super.key});

  static const _horizontalPadding = 20.0;
  static const _itemSpacing = 12.0;

  final HomeProductSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Text(
              section.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.darkChocolate,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: ListProductItem.height,
            child: ListView.builder(
              key: PageStorageKey(section.id),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              itemExtent: ListProductItem.width + _itemSpacing,
              cacheExtent: (ListProductItem.width + _itemSpacing) * 3,
              itemCount: section.products.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: ListProductItem(
                    key: ValueKey(section.products[index].id),
                    product: section.products[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
