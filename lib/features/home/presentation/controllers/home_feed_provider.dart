import 'dart:async';
import 'dart:math' as math;

import 'package:bbo_shop_app/features/home/presentation/controllers/home_category_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _homeProductsPageSize = 10;

final homeFeedSectionsProvider = Provider<List<HomeProductSection>>((ref) {
  final category = ref.watch(homeCategoryControllerProvider);
  return _buildSections(category);
});

final homeFeedRepositoryProvider = Provider<HomeFeedRepository>((ref) {
  return const MockHomeFeedRepository();
});

final homeProductPageControllerProvider =
    NotifierProvider.family<
      HomeProductPageController,
      HomeProductPageState,
      HomeProductSectionKey
    >((sectionKey) => HomeProductPageController(sectionKey));

class HomeProductSection {
  const HomeProductSection({
    required this.id,
    required this.title,
    required this.key,
  });

  final String id;
  final String title;
  final HomeProductSectionKey key;
}

class HomeProductSectionKey {
  const HomeProductSectionKey({
    required this.category,
    required this.sectionIndex,
  });

  final HomeCategory category;
  final int sectionIndex;

  String get id => '${category.name}-${sectionIndex + 1}';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeProductSectionKey &&
            other.category == category &&
            other.sectionIndex == sectionIndex;
  }

  @override
  int get hashCode => Object.hash(category, sectionIndex);
}

class HomeProductPreview {
  const HomeProductPreview({
    required this.id,
    required this.name,
    required this.price,
    required this.sellerInfo,
    required this.photoUrl,
  });

  final String id;
  final String name;
  final String price;
  final String sellerInfo;
  final String photoUrl;
}

class HomeProductPageState {
  const HomeProductPageState({
    required this.products,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
    required this.isInitialLoading,
    required this.isLoadingNextPage,
    this.errorMessage,
  });

  factory HomeProductPageState.initial({required int pageSize}) {
    return HomeProductPageState(
      products: const [],
      pageNumber: -1,
      pageSize: pageSize,
      totalElements: 0,
      totalPages: 0,
      isLast: false,
      isInitialLoading: true,
      isLoadingNextPage: false,
    );
  }

  final List<HomeProductPreview> products;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
  final bool isInitialLoading;
  final bool isLoadingNextPage;
  final String? errorMessage;

  int get nextPageNumber => pageNumber + 1;

  bool get canLoadNextPage {
    return !isInitialLoading && !isLoadingNextPage && !isLast;
  }

  bool get shouldShowFooter {
    return isInitialLoading || isLoadingNextPage || errorMessage != null;
  }

  HomeProductPageState copyWith({
    List<HomeProductPreview>? products,
    int? pageNumber,
    int? pageSize,
    int? totalElements,
    int? totalPages,
    bool? isLast,
    bool? isInitialLoading,
    bool? isLoadingNextPage,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HomeProductPageState(
      products: products ?? this.products,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalElements: totalElements ?? this.totalElements,
      totalPages: totalPages ?? this.totalPages,
      isLast: isLast ?? this.isLast,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class HomeProductPageController extends Notifier<HomeProductPageState> {
  HomeProductPageController(this._sectionKey);

  final HomeProductSectionKey _sectionKey;
  late final HomeFeedRepository _repository;

  @override
  HomeProductPageState build() {
    _repository = ref.watch(homeFeedRepositoryProvider);
    scheduleMicrotask(() {
      if (ref.mounted) {
        unawaited(_loadPage(pageNumber: 0, replaceProducts: true));
      }
    });
    return HomeProductPageState.initial(pageSize: _homeProductsPageSize);
  }

  Future<void> loadNextPage() async {
    if (!state.canLoadNextPage) {
      return;
    }

    await _loadPage(pageNumber: state.nextPageNumber, replaceProducts: false);
  }

  Future<void> retry() async {
    if (state.isInitialLoading || state.isLoadingNextPage) {
      return;
    }

    final nextPageNumber = state.products.isEmpty ? 0 : state.nextPageNumber;
    await _loadPage(
      pageNumber: nextPageNumber,
      replaceProducts: state.products.isEmpty,
    );
  }

  Future<void> _loadPage({
    required int pageNumber,
    required bool replaceProducts,
  }) async {
    final isInitialRequest = replaceProducts && state.products.isEmpty;
    state = state.copyWith(
      isInitialLoading: isInitialRequest,
      isLoadingNextPage: !isInitialRequest,
      clearErrorMessage: true,
    );

    try {
      final page = await _repository.fetchSectionProducts(
        sectionKey: _sectionKey,
        pageNumber: pageNumber,
        pageSize: state.pageSize,
      );

      if (!ref.mounted) {
        return;
      }

      final products = replaceProducts
          ? page.content
          : List<HomeProductPreview>.unmodifiable([
              ...state.products,
              ...page.content,
            ]);

      state = state.copyWith(
        products: products,
        pageNumber: page.pageNumber,
        pageSize: page.pageSize,
        totalElements: page.totalElements,
        totalPages: page.totalPages,
        isLast: page.isLast,
        isInitialLoading: false,
        isLoadingNextPage: false,
        clearErrorMessage: true,
      );
    } catch (_) {
      if (!ref.mounted) {
        return;
      }

      state = state.copyWith(
        isInitialLoading: false,
        isLoadingNextPage: false,
        errorMessage: 'Impossible de charger les produits.',
      );
    }
  }
}

abstract class HomeFeedRepository {
  Future<HomePageResponse<HomeProductPreview>> fetchSectionProducts({
    required HomeProductSectionKey sectionKey,
    required int pageNumber,
    required int pageSize,
  });
}

class HomePageResponse<T> {
  const HomePageResponse({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  final List<T> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
}

class MockHomeFeedRepository implements HomeFeedRepository {
  const MockHomeFeedRepository({
    this.responseDelay = const Duration(milliseconds: 450),
    this.totalElementsPerSection = 34,
  });

  final Duration responseDelay;
  final int totalElementsPerSection;

  @override
  Future<HomePageResponse<HomeProductPreview>> fetchSectionProducts({
    required HomeProductSectionKey sectionKey,
    required int pageNumber,
    required int pageSize,
  }) async {
    if (responseDelay > Duration.zero) {
      await Future<void>.delayed(responseDelay);
    }

    final totalPages = (totalElementsPerSection / pageSize).ceil();
    final startIndex = pageNumber * pageSize;
    final endIndex = math.min(startIndex + pageSize, totalElementsPerSection);
    final content = startIndex >= totalElementsPerSection
        ? const <HomeProductPreview>[]
        : List<HomeProductPreview>.unmodifiable(
            List.generate(endIndex - startIndex, (index) {
              return _buildProductPreview(
                category: sectionKey.category,
                sectionIndex: sectionKey.sectionIndex,
                productIndex: startIndex + index,
              );
            }),
          );

    return HomePageResponse<HomeProductPreview>(
      content: content,
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElementsPerSection,
      totalPages: totalPages,
      isLast: pageNumber >= totalPages - 1,
    );
  }
}

List<HomeProductSection> _buildSections(HomeCategory category) {
  return List<HomeProductSection>.unmodifiable(
    List.generate(8, (sectionIndex) {
      final key = HomeProductSectionKey(
        category: category,
        sectionIndex: sectionIndex,
      );

      return HomeProductSection(
        id: key.id,
        title: _sectionTitles(category)[sectionIndex],
        key: key,
      );
    }),
  );
}

HomeProductPreview _buildProductPreview({
  required HomeCategory category,
  required int sectionIndex,
  required int productIndex,
}) {
  final catalog = switch (category) {
    HomeCategory.products => _productCatalog,
    HomeCategory.services => _serviceCatalog,
    HomeCategory.experiences => _experienceCatalog,
  };
  final item = catalog[(sectionIndex + productIndex) % catalog.length];
  final district =
      _districts[(sectionIndex + productIndex) % _districts.length];
  final seed = '${category.name}-${sectionIndex + 1}-${productIndex + 1}';

  return HomeProductPreview(
    id: seed,
    name: item.name,
    price: item.price,
    sellerInfo: '${item.seller} - $district',
    photoUrl: 'https://picsum.photos/seed/yangu-$seed/640/480',
  );
}

List<String> _sectionTitles(HomeCategory category) {
  return switch (category) {
    HomeCategory.products => const [
      'Populaire à Butembo',
      'Arrivages du marché',
      'Pour la maison',
      'Mode locale',
      'Téléphones et accessoires',
      'Beauté et soins',
      'Bonnes affaires',
      'Vendeurs proches de vous',
    ],
    HomeCategory.services => const [
      'Services demandés',
      'Réparateurs disponibles',
      'Livraison et courses',
      'Maison et entretien',
      'Coiffure et beauté',
      'Aide informatique',
      'Services rapides',
      'Professionnels proches',
    ],
    HomeCategory.experiences => const [
      'Sorties à découvrir',
      'Activités du week-end',
      'Saveurs locales',
      'Ateliers et formations',
      'Moments en famille',
      'Culture et événements',
      'Découvertes proches',
      'Nouveautés à Butembo',
    ],
  };
}

const _districts = [
  'Centre-ville',
  'Furu',
  'Vutetse',
  'Kimemi',
  'Bulengera',
  'Mukuna',
];

const _productCatalog = [
  _CatalogItem('Riz local 5 kg', '12 000 CDF', 'Chez Amina'),
  _CatalogItem('Huile végétale', '8 500 CDF', 'Boutique Baraka'),
  _CatalogItem('Baskets homme', '22 USD', 'Kivu Style'),
  _CatalogItem('Sac à main', '18 USD', 'Maison Neema'),
  _CatalogItem('Chargeur USB-C', '7 USD', 'Tech Plus'),
  _CatalogItem('Savon en carton', '15 000 CDF', 'Dépôt Umoja'),
  _CatalogItem('Chemise wax', '14 USD', 'Atelier Grâce'),
  _CatalogItem('Farine de maïs', '9 000 CDF', 'Marché Central'),
];

const _serviceCatalog = [
  _CatalogItem('Réparation téléphone', 'Dès 10 USD', 'Tech Plus'),
  _CatalogItem('Livraison moto', '3 000 CDF', 'Rapide Butembo'),
  _CatalogItem('Coiffure dame', 'Dès 8 USD', 'Salon Neema'),
  _CatalogItem('Installation solaire', 'Sur devis', 'Kivu Energie'),
  _CatalogItem('Nettoyage maison', '15 USD', 'Equipe Safi'),
  _CatalogItem('Maintenance PC', 'Dès 12 USD', 'Info Service'),
  _CatalogItem('Couture express', 'Dès 5 USD', 'Atelier Grâce'),
  _CatalogItem('Transport colis', '4 000 CDF', 'Moto Express'),
];

const _experienceCatalog = [
  _CatalogItem('Dîner local', '12 USD', 'Table Kivu'),
  _CatalogItem('Atelier pâtisserie', '8 USD', 'Maison Sucrée'),
  _CatalogItem('Visite guidée', '10 USD', 'Explore Butembo'),
  _CatalogItem('Cours de danse', '5 USD', 'Studio Umoja'),
  _CatalogItem('Brunch familial', '18 USD', 'Jardin Neema'),
  _CatalogItem('Formation photo', '15 USD', 'Pixel Kivu'),
  _CatalogItem('Soirée acoustique', '6 USD', 'Café Baraka'),
  _CatalogItem('Atelier peinture', '7 USD', 'Art Local'),
];

class _CatalogItem {
  const _CatalogItem(this.name, this.price, this.seller);

  final String name;
  final String price;
  final String seller;
}
