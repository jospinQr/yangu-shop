import 'package:bbo_shop_app/features/home/presentation/controllers/home_category_controller.dart';
import 'package:bbo_shop_app/features/home/presentation/controllers/home_feed_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes eight sections with horizontal products', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sections = container.read(homeFeedSectionsProvider);

    expect(sections, hasLength(8));
    expect(sections.every((section) => section.products.length == 12), isTrue);
  });

  test('updates simulated sections when the home category changes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container
        .read(homeCategoryControllerProvider.notifier)
        .select(HomeCategory.services);

    final sections = container.read(homeFeedSectionsProvider);

    expect(sections.first.id, startsWith('services-'));
  });
}
