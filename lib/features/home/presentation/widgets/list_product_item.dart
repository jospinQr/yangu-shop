import 'package:bbo_shop_app/core/theme/app_colors.dart';
import 'package:bbo_shop_app/features/home/presentation/controllers/home_feed_provider.dart';
import 'package:flutter/material.dart';

class ListProductItem extends StatelessWidget {
  const ListProductItem({required this.product, this.onTap, super.key});

  static const width = 164.0;
  static const height = 230.0;
  static const _imageHeight = 142.0;
  static const _borderRadius = BorderRadius.all(Radius.circular(8));

  final HomeProductPreview product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageCacheWidth = (width * MediaQuery.devicePixelRatioOf(context))
        .round();

    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: Semantics(
          label: '${product.name}, ${product.price}, ${product.sellerInfo}',
          button: onTap != null,
          child: InkWell(
            borderRadius: _borderRadius,
            onTap: onTap,
            child: _ListProductItemContent(
              product: product,
              imageCacheWidth: imageCacheWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class _ListProductItemContent extends StatelessWidget {
  const _ListProductItemContent({
    required this.product,
    required this.imageCacheWidth,
  });

  final HomeProductPreview product;
  final int imageCacheWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: ListProductItem._borderRadius,
          child: SizedBox(
            width: ListProductItem.width,
            height: ListProductItem._imageHeight,
            child: _ProductPhoto(
              photoUrl: product.photoUrl,
              imageCacheWidth: imageCacheWidth,
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.darkChocolate,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          product.price,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.chocolate,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          product.sellerInfo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.mutedText,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _ProductPhoto extends StatelessWidget {
  const _ProductPhoto({required this.photoUrl, required this.imageCacheWidth});

  final String photoUrl;
  final int imageCacheWidth;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Image.network(
      photoUrl,
      fit: BoxFit.cover,
      cacheWidth: imageCacheWidth,
      filterQuality: FilterQuality.low,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || reduceMotion) {
          return child;
        }

        final hasFrame = frame != null;

        return Stack(
          fit: StackFit.expand,
          children: [
            const _ProductImageFallback(),
            AnimatedOpacity(
              opacity: hasFrame ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: child,
            ),
          ],
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const _ProductImageFallback();
      },
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.milkFoam,
        borderRadius: ListProductItem._borderRadius,
      ),
      child: Center(
        child: Image.asset(
          'assets/icon/marquer.png',
          width: 44,
          height: 44,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
