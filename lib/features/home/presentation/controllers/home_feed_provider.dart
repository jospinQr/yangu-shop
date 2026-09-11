import 'package:bbo_shop_app/features/home/presentation/controllers/home_category_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeFeedSectionsProvider = Provider<List<HomeProductSection>>((ref) {
  final category = ref.watch(homeCategoryControllerProvider);
  return _buildSections(category);
});

class HomeProductSection {
  const HomeProductSection({
    required this.id,
    required this.title,
    required this.products,
  });

  final String id;
  final String title;
  final List<HomeProductPreview> products;
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

List<HomeProductSection> _buildSections(HomeCategory category) {
  final catalog = switch (category) {
    HomeCategory.products => _productCatalog,
    HomeCategory.services => _serviceCatalog,
    HomeCategory.experiences => _experienceCatalog,
  };

  return List<HomeProductSection>.unmodifiable(
    List.generate(8, (sectionIndex) {
      final sectionNumber = sectionIndex + 1;
      final title = _sectionTitles(category)[sectionIndex];
      final products = List<HomeProductPreview>.unmodifiable(
        List.generate(12, (productIndex) {
          final item = catalog[(sectionIndex + productIndex) % catalog.length];
          final district =
              _districts[(sectionIndex + productIndex) % _districts.length];
          final seed = '${category.name}-$sectionNumber-${productIndex + 1}';

          return HomeProductPreview(
            id: seed,
            name: item.name,
            price: item.price,
            sellerInfo: '${item.seller} · $district',
            photoUrl: 'https://picsum.photos/seed/yangu-$seed/640/480',
          );
        }),
      );

      return HomeProductSection(
        id: '${category.name}-$sectionNumber',
        title: title,
        products: products,
      );
    }),
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
