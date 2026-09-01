import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeCategory {
  products('Produits'),
  services('Services'),
  experiences('Expériences');

  const HomeCategory(this.label);

  final String label;
}

class HomeCategoryController extends Notifier<HomeCategory> {
  @override
  HomeCategory build() {
    return HomeCategory.products;
  }

  void select(HomeCategory category) {
    state = category;
  }
}

final homeCategoryControllerProvider =
    NotifierProvider<HomeCategoryController, HomeCategory>(
      HomeCategoryController.new,
    );
