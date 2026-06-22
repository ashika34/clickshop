import 'package:click_shop/Feature/Home/Productdetail/viewmodel/product_detailstate_viewmodel.dart';
import 'package:click_shop/Feature/Home/Productdetail/model/product_details_model.dart';
import 'package:click_shop/Feature/Home/Productdetail/viewmodel/product_details_view_model.dart';
import 'package:click_shop/Feature/Home/My cart/viewmodel/cart_view_model.dart';
import 'package:click_shop/config/app_route.dart';
import 'package:click_shop/config/app_theme.dart';
import 'package:click_shop/core/widgets/skeleton_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  const ProductDetailView({required this.productId, super.key});

  final int productId;

  @override
  ConsumerState<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectImage(int index) {
    ref.read(productDetailUiProvider.notifier).selectImage(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(productDetailUiProvider);
    final cartItemCount = ref.watch(cartItemCountProvider);
    final productState = ref.watch(
      productDetailsViewModelProvider(widget.productId),
    );
    final screenSize = MediaQuery.sizeOf(context);
    final galleryHeight = (screenSize.height * 0.40).clamp(320.0, 480.0);

    return productState.when(
      data: (product) {
        final images = product.galleryImages.isEmpty
            ? const <String>['']
            : product.galleryImages;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: 76,
            leadingWidth: 76,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: _CircleActionButton(
                icon: Icons.arrow_back_rounded,
                onPressed: _goBack,
              ),
            ),
            actions: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _CircleActionButton(
                    icon: Icons.shopping_cart_outlined,
                    onPressed: () => context.push(AppRoutes.cart),
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      right: -4,
                      top: -5,
                      child: _CartBadge(count: cartItemCount),
                    ),
                ],
              ),
              const SizedBox(width: 20),
            ],
          ),
          bottomNavigationBar: _PurchaseBar(
            onAddToCart: () =>
                ref.read(cartViewModelProvider.notifier).addProduct(product),
          ),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: galleryHeight,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: images.length,
                              onPageChanged: ref
                                  .read(productDetailUiProvider.notifier)
                                  .selectImage,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  52,
                                  26,
                                  52,
                                  42,
                                ),
                                child: _ProductImage(url: images[index]),
                              ),
                            ),
                            Positioned(
                              bottom: 14,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(images.length, (index) {
                                  final selected =
                                      detailState.selectedImage == index;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? AppColors.darkGreen
                                          : const Color(0xFFD2D4D2),
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 98,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => _selectImage(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: 112,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: detailState.selectedImage == index
                                      ? AppColors.darkGreen
                                      : const Color(0xFFE0E3E0),
                                  width: detailState.selectedImage == index
                                      ? 1.8
                                      : 1,
                                ),
                              ),
                              child: _ProductImage(url: images[index]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ProductInformation(product: product),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => _ProductDetailSkeleton(onBack: _goBack),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: Center(
          child: IconButton(
            tooltip: 'Retry product details',
            color: AppColors.darkGreen,
            icon: const Icon(Icons.refresh_rounded),
            onPressed: ref
                .read(
                  productDetailsViewModelProvider(widget.productId).notifier,
                )
                .retry,
          ),
        ),
      ),
    );
  }
}

class _ProductDetailSkeleton extends StatelessWidget {
  const _ProductDetailSkeleton({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final galleryHeight = (screenSize.height * 0.40).clamp(320.0, 480.0);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 76,
        leadingWidth: 76,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: _CircleActionButton(
            icon: Icons.arrow_back_rounded,
            onPressed: onBack,
          ),
        ),
        actions: const [
          SkeletonBox(width: 46, height: 46, borderRadius: 23),
          SizedBox(width: 20),
        ],
      ),
      bottomNavigationBar: const _PurchaseBarSkeleton(),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(52, 20, 52, 34),
                  child: SkeletonBox(
                    width: double.infinity,
                    height: galleryHeight - 54,
                    borderRadius: 24,
                  ),
                ),
                SizedBox(
                  height: 98,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) => const SkeletonBox(
                      width: 112,
                      height: 98,
                      borderRadius: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 82, height: 16, borderRadius: 6),
                      SizedBox(height: 12),
                      SkeletonBox(
                        width: double.infinity,
                        height: 27,
                        borderRadius: 7,
                      ),
                      SizedBox(height: 16),
                      SkeletonBox(width: 170, height: 18, borderRadius: 6),
                      SizedBox(height: 20),
                      SkeletonBox(width: 220, height: 28, borderRadius: 7),
                      SizedBox(height: 20),
                      SkeletonBox(
                        width: double.infinity,
                        height: 70,
                        borderRadius: 9,
                      ),
                      SizedBox(height: 28),
                      SkeletonBox(width: 145, height: 20, borderRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PurchaseBarSkeleton extends StatelessWidget {
  const _PurchaseBarSkeleton();

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: const SkeletonBox(
          width: double.infinity,
          height: 54,
          borderRadius: 11,
        ),
      ),
    ),
  );
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const Icon(
        Icons.image_not_supported_outlined,
        size: 100,
        color: Color(0xFF777A80),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.headphones_rounded,
        size: 130,
        color: Color(0xFF202224),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      shape: BoxShape.circle,
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 16,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
        size: 25,
      ),
    ),
  );
}

class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 21, minHeight: 21),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          height: 1,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProductInformation extends StatelessWidget {
  const _ProductInformation({required this.product});

  final ProductDetailsModel product;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.brand,
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        Text(
          product.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 23,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 16),
        _RatingLine(product: product),
        SizedBox(height: 18),
        _PriceLine(product: product),
        SizedBox(height: 20),
        Text(
          product.description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 15,
            height: 1.45,
          ),
        ),
        SizedBox(height: 28),
        Text(
          'Product Details',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 14),
        _FeatureList(product: product),
        SizedBox(height: 24),
        _SpecificationList(product: product),
      ],
    ),
  );
}

class _RatingLine extends StatelessWidget {
  const _RatingLine({required this.product});
  final ProductDetailsModel product;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.star_rounded, color: AppColors.darkGreen, size: 23),
      const SizedBox(width: 6),
      Text(
        product.rating.toStringAsFixed(1),
        style: const TextStyle(
          color: AppColors.darkGreen,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(width: 14),
      const SizedBox(height: 20, child: VerticalDivider(width: 1)),
      const SizedBox(width: 14),
      Text(
        '${product.reviews.length} Ratings',
        style: const TextStyle(color: Color(0xFF555960), fontSize: 15),
      ),
    ],
  );
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.product});
  final ProductDetailsModel product;

  @override
  Widget build(BuildContext context) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 18,
    runSpacing: 8,
    children: [
      Text(
        '\$${product.price.toStringAsFixed(2)}',
        style: const TextStyle(
          color: AppColors.darkGreen,
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
      ),
      Text(
        '\$${product.originalPrice.toStringAsFixed(2)}',
        style: const TextStyle(
          color: Color(0xFF777A80),
          fontSize: 15,
          decoration: TextDecoration.lineThrough,
        ),
      ),
      Text(
        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
        style: const TextStyle(
          color: Color(0xFFE63535),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _FeatureList extends StatelessWidget {
  const _FeatureList({required this.product});
  final ProductDetailsModel product;

  @override
  Widget build(BuildContext context) {
    final features = [
      (Icons.local_shipping_outlined, product.shippingInformation),
      (Icons.verified_user_outlined, product.warrantyInformation),
      (Icons.inventory_2_outlined, product.availabilityStatus),
      (Icons.assignment_return_outlined, product.returnPolicy),
      (Icons.scale_outlined, '${product.weight.toStringAsFixed(1)} kg'),
    ];
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: features.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final feature = features[index];
          return Container(
            width: 104,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E5E2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(feature.$1, color: AppColors.darkGreen, size: 31),
                const SizedBox(height: 8),
                Text(
                  feature.$2,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF25282C),
                    fontSize: 12.5,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SpecificationList extends StatelessWidget {
  const _SpecificationList({required this.product});
  final ProductDetailsModel product;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dimensions = product.dimensions;
    final specifications = [
      ('Brand', product.brand),
      ('Category', product.category),
      ('Stock', '${product.stock} (${product.availabilityStatus})'),
      ('SKU', product.sku),
      ('Warranty', product.warrantyInformation),
      ('Shipping', product.shippingInformation),
      ('Return Policy', product.returnPolicy),
      ('Minimum Order', product.minimumOrderQuantity.toString()),
      ('Barcode', product.meta.barcode),
      ('Weight', product.weight.toStringAsFixed(1)),
      (
        'Dimensions',
        '${dimensions.width} × ${dimensions.height} × ${dimensions.depth}',
      ),
      ('Tags', product.tags.join(', ')),
    ];
    return Column(
      children: specifications
          .map((specification) {
            final inStock = specification.$1 == 'Stock';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      specification.$1,
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF303338),
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      specification.$2,
                      style: TextStyle(
                        color: inStock
                            ? (isDarkMode ? Colors.white : AppColors.darkGreen)
                            : (isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF202328)),
                        fontSize: 14.5,
                        fontWeight: inStock ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

class _PurchaseBar extends StatelessWidget {
  const _PurchaseBar({required this.onAddToCart});

  final VoidCallback onAddToCart;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: _PurchaseButton(
            icon: Icons.shopping_cart_outlined,
            label: 'Add to Cart',
            onPressed: onAddToCart,
          ),
        ),
      ),
    ),
  );
}

class _PurchaseButton extends StatelessWidget {
  const _PurchaseButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.darkGreen, AppColors.lightGreen],
      ),
      borderRadius: BorderRadius.circular(11),
    ),
    child: SizedBox(
      height: 54,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        icon: Icon(icon, color: Colors.white, size: 25),
        label: Text(
          label,
          maxLines: 1,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}
