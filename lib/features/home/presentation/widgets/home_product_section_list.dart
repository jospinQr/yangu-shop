import 'package:bbo_shop_app/core/theme/app_colors.dart';
import 'package:bbo_shop_app/features/home/presentation/controllers/home_feed_provider.dart';
import 'package:bbo_shop_app/features/home/presentation/widgets/list_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeProductSectionList extends ConsumerStatefulWidget {
  const HomeProductSectionList({required this.section, super.key});

  final HomeProductSection section;

  @override
  ConsumerState<HomeProductSectionList> createState() {
    return _HomeProductSectionListState();
  }
}

class _HomeProductSectionListState
    extends ConsumerState<HomeProductSectionList> {
  static const _horizontalPadding = 20.0;
  static const _itemSpacing = 12.0;
  static const _itemExtent = ListProductItem.width + _itemSpacing;
  static const _nextPageThreshold = _itemExtent * 2;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    final distanceToEnd = position.maxScrollExtent - position.pixels;
    if (distanceToEnd > _nextPageThreshold) {
      return;
    }

    ref
        .read(homeProductPageControllerProvider(widget.section.key).notifier)
        .loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pageState = ref.watch(
      homeProductPageControllerProvider(widget.section.key),
    );
    final products = pageState.products;
    final itemCount = products.length + (pageState.shouldShowFooter ? 1 : 0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Text(
              widget.section.title,
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
              key: PageStorageKey(widget.section.id),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              itemExtent: _itemExtent,
              scrollCacheExtent: const ScrollCacheExtent.pixels(
                _itemExtent * 3,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index < products.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: _AnimatedProductListItem(
                      key: ValueKey(products[index].id),
                      index: index,
                      child: ListProductItem(product: products[index]),
                    ),
                  );
                }

                return Align(
                  alignment: Alignment.centerLeft,
                  child: _ProductPageFooter(
                    isLoading:
                        pageState.isInitialLoading ||
                        pageState.isLoadingNextPage,
                    errorMessage: pageState.errorMessage,
                    onRetry: () {
                      ref
                          .read(
                            homeProductPageControllerProvider(
                              widget.section.key,
                            ).notifier,
                          )
                          .retry();
                    },
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

class _ProductPageFooter extends StatelessWidget {
  const _ProductPageFooter({
    required this.isLoading,
    required this.onRetry,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final body = isLoading
        ? const _ProductPageLoadingFooter()
        : _ProductPageRetryFooter(errorMessage: errorMessage, onRetry: onRetry);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: body,
    );
  }
}

class _AnimatedProductListItem extends StatelessWidget {
  const _AnimatedProductListItem({
    required this.index,
    required this.child,
    super.key,
  });

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return child;
    }

    final duration = Duration(milliseconds: 170 + ((index % 4) * 18));

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(8 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _ProductPageLoadingFooter extends StatelessWidget {
  const _ProductPageLoadingFooter();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      key: ValueKey('home-product-page-loading'),
      width: ListProductItem.width,
      height: ListProductItem.height,
      child: Center(
        child: SizedBox.square(
          dimension: 28,
          child: CircularProgressIndicator(strokeWidth: 2.6),
        ),
      ),
    );
  }
}

class _ProductPageRetryFooter extends StatelessWidget {
  const _ProductPageRetryFooter({
    required this.errorMessage,
    required this.onRetry,
  });

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('home-product-page-retry'),
      width: ListProductItem.width,
      height: ListProductItem.height,
      child: Center(
        child: TextButton(
          onPressed: onRetry,
          child: Text(
            errorMessage ?? 'Réessayer',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
