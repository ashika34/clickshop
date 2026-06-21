import 'package:click_shop/Feature/Home/Category/model/category_model.dart';
import 'package:click_shop/Feature/Home/Category/viewmodel/category_view_model.dart';
import 'package:click_shop/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryView extends ConsumerWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryViewModelProvider);

    return SizedBox(
      height: 132,
      child: categories.when(
        data: (items) => ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 18),
          itemBuilder: (context, index) =>
              _CategoryCard(category: items[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: IconButton(
            tooltip: 'Retry categories',
            onPressed: ref.read(categoryViewModelProvider.notifier).retry,
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.darkGreen,
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              _iconFor(category.slug),
              color: AppColors.darkGreen,
              size: 34,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            category.name,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF555960),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String slug) {
    if (slug.contains('beauty') || slug.contains('skin')) {
      return Icons.spa_outlined;
    }
    if (slug.contains('furniture') || slug.contains('home')) {
      return Icons.chair_outlined;
    }
    if (slug.contains('groceries') || slug.contains('kitchen')) {
      return Icons.shopping_basket_outlined;
    }
    if (slug.contains('phone') || slug.contains('mobile')) {
      return Icons.smartphone_outlined;
    }
    if (slug.contains('laptop') || slug.contains('tablet')) {
      return Icons.devices_outlined;
    }
    if (slug.contains('watch')) return Icons.watch_outlined;
    if (slug.contains('shoe')) return Icons.directions_run_rounded;
    if (slug.contains('bag')) return Icons.shopping_bag_outlined;
    if (slug.contains('vehicle') || slug.contains('motorcycle')) {
      return Icons.two_wheeler_outlined;
    }
    if (slug.contains('jewellery')) return Icons.diamond_outlined;
    if (slug.contains('shirt') ||
        slug.contains('dress') ||
        slug.contains('tops')) {
      return Icons.checkroom_rounded;
    }
    return Icons.category_outlined;
  }
}
