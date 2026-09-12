import 'package:bbo_shop_app/features/home/presentation/controllers/home_category_controller.dart';
import 'package:bbo_shop_app/features/home/presentation/controllers/home_feed_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        homeFeedRepositoryProvider.overrideWithValue(
          const MockHomeFeedRepository(responseDelay: Duration.zero),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> pumpInitialProductPage() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }

  test('exposes eight sections for the selected home category', () {
    final container = buildContainer();

    final sections = container.read(homeFeedSectionsProvider);

    expect(sections, hasLength(8));
    expect(sections.first.id, 'products-1');
  });

  test('updates simulated sections when the home category changes', () {
    final container = buildContainer();

    container
        .read(homeCategoryControllerProvider.notifier)
        .select(HomeCategory.services);

    final sections = container.read(homeFeedSectionsProvider);

    expect(sections.first.id, startsWith('services-'));
  });

  test(
    'loads section products page by page with Spring pagination metadata',
    () async {
      final container = buildContainer();
      final section = container.read(homeFeedSectionsProvider).first;
      final provider = homeProductPageControllerProvider(section.key);

      expect(container.read(provider).isInitialLoading, isTrue);

      await pumpInitialProductPage();

      var state = container.read(provider);
      expect(state.products, hasLength(10));
      expect(state.pageNumber, 0);
      expect(state.pageSize, 10);
      expect(state.totalElements, 34);
      expect(state.totalPages, 4);
      expect(state.isLast, isFalse);

      await container.read(provider.notifier).loadNextPage();

      state = container.read(provider);
      expect(state.products, hasLength(20));
      expect(state.pageNumber, 1);
      expect(state.isLoadingNextPage, isFalse);
      expect(state.isLast, isFalse);
    },
  );

  test('stops requesting more products after the last page', () async {
    final container = buildContainer();
    final section = container.read(homeFeedSectionsProvider).first;
    final provider = homeProductPageControllerProvider(section.key);

    container.read(provider);
    await pumpInitialProductPage();
    await container.read(provider.notifier).loadNextPage();
    await container.read(provider.notifier).loadNextPage();
    await container.read(provider.notifier).loadNextPage();

    final lastPageState = container.read(provider);
    expect(lastPageState.products, hasLength(34));
    expect(lastPageState.pageNumber, 3);
    expect(lastPageState.isLast, isTrue);

    await container.read(provider.notifier).loadNextPage();

    final unchangedState = container.read(provider);
    expect(unchangedState.products, hasLength(34));
    expect(unchangedState.pageNumber, 3);
  });
}
