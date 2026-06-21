import 'package:click_shop/Feature/Home/Productlisting/model/product_listing_model.dart';
import 'package:click_shop/Feature/Home/Productlisting/viewmodel/product_listing_viewmodel.dart';
import 'package:click_shop/config/app_route.dart';
import 'package:click_shop/config/app_theme.dart';
import 'package:click_shop/core/widgets/skeleton_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductListingView extends ConsumerWidget {
  const ProductListingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListingViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Popular Products',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: AppColors.darkGreen),
              child: const Text(
                'See All',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 270,
          child: products.when(
            data: (items) => LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (MediaQuery.sizeOf(context).width * 0.43)
                    .clamp(158.0, 205.0);
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) => SizedBox(
                    width: cardWidth,
                    child: _ProductCard(product: items[index]),
                  ),
                );
              },
            ),
            loading: () => LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (MediaQuery.sizeOf(context).width * 0.43)
                    .clamp(158.0, 205.0);
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) => SizedBox(
                    width: cardWidth,
                    child: const _ProductCardSkeleton(),
                  ),
                );
              },
            ),
            error: (error, stackTrace) => Center(
              child: IconButton(
                tooltip: 'Retry products',
                onPressed: ref
                    .read(productListingViewModelProvider.notifier)
                    .retry,
                icon: const Icon(Icons.refresh_rounded),
                color: AppColors.darkGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9ECE9)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SkeletonBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 14,
            ),
          ),
          SizedBox(height: 10),
          SkeletonBox(width: 72, height: 10, borderRadius: 5),
          SizedBox(height: 7),
          SkeletonBox(width: 125, height: 15, borderRadius: 6),
          SizedBox(height: 8),
          SkeletonBox(width: 76, height: 18, borderRadius: 6),
          SizedBox(height: 8),
          SkeletonBox(width: 92, height: 12, borderRadius: 6),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetailPath(product.id)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9ECE9)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ColoredBox(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported_outlined,
                                color: Color(0xFF9A9E9A),
                                size: 42,
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 7,
                      top: 7,
                      child: IconButton(
                        onPressed: () {},
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          color: Color(0xFF7E848B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB71B),
                          size: 19,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${product.rating.toStringAsFixed(1)} '
                            '(${product.reviewCount})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
