import 'package:click_shop/Feature/Home/My cart/model/cart_item_model.dart';
import 'package:click_shop/Feature/Home/My cart/viewmodel/cart_view_model.dart';
import 'package:click_shop/config/app_route.dart';
import 'package:click_shop/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:input_quantity/input_quantity.dart';

class MyCart extends ConsumerWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartViewModelProvider);
    final subtotal = ref.watch(cartSubtotalProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _OrderSummary(subtotal: subtotal),
      body: items.isEmpty
          ? const _EmptyCart()
          : SafeArea(
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) => _CartItemCard(
                      item: items[index],
                      onDelete: () => ref
                          .read(cartViewModelProvider.notifier)
                          .removeAt(index),
                      onQuantityChanged: (quantity) => ref
                          .read(cartViewModelProvider.notifier)
                          .updateQuantity(items[index].id, quantity),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  final CartItemModel item;
  final VoidCallback onDelete;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetailPath(item.id)),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECE8)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 96,
              height: 96,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: item.image.isEmpty
                  ? const Icon(
                      Icons.image_not_supported_outlined,
                      color: Color(0xFF8B908B),
                    )
                  : Image.network(
                      item.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFF8B908B),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputQty.int(
                    key: ValueKey('${item.id}-${item.quantity}'),
                    initVal: item.quantity,
                    minVal: 0,
                    maxVal: 9999,
                    steps: 1,
                    onQtyChanged: (value) =>
                        onQuantityChanged((value as num).toInt()),
                    messageBuilder: (minVal, maxVal, value) =>
                        const SizedBox.shrink(),
                    qtyFormProps: const QtyFormProps(
                      enableTyping: false,
                      showCursor: false,
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    decoration: QtyDecorationProps(
                      width: 2,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      btnColor: AppColors.darkGreen,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE8ECE8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.darkGreen,
                        ),
                      ),
                      minusButtonConstrains: const BoxConstraints.tightFor(
                        width: 30,
                        height: 32,
                      ),
                      plusButtonConstrains: const BoxConstraints.tightFor(
                        width: 30,
                        height: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  tooltip: 'Remove from cart',
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints.tightFor(
                    width: 36,
                    height: 36,
                  ),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.black,
                    size: 23,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: 12,
        shadowColor: const Color(0x18000000),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
          child: Align(
            alignment: Alignment.center,
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SummaryRow(
                    label: 'Subtotal',
                    value: '\$${subtotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 10),
                  const _SummaryRow(label: 'Shipping', value: 'Free'),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.darkGreen, AppColors.lightGreen],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FilledButton(
                        onPressed: () => context.push(AppRoutes.checkout),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 15,
        ),
      ),
      const Spacer(),
      Text(
        value,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.shopping_cart_outlined, size: 70, color: Color(0xFFABB0AB)),
        SizedBox(height: 14),
        Text(
          'Your cart is empty',
          style: TextStyle(
            color: Color(0xFF303338),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
