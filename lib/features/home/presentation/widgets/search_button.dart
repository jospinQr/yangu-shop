import 'package:bbo_shop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 2),
        child: Card(
          color: AppColors.warmCream,
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.search_outlined),
                SizedBox(width: 8),
                Text(
                  "Commencer ma recherche",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
