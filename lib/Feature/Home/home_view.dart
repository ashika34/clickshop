import 'package:click_shop/Feature/Home/Category/view/category_view.dart';
import 'package:click_shop/Feature/Home/My cart/viewmodel/cart_view_model.dart';
import 'package:click_shop/Feature/Home/Productlisting/view/product_listing_view.dart';
import 'package:click_shop/Feature/Home/widgets/bottom_nav_bar.dart';
import 'package:click_shop/Feature/Home/widgets/home_slider.dart';
import 'package:click_shop/Feature/Home/widgets/profile.dart';
import 'package:click_shop/Feature/LoginScreen/Viewmodel/login_view_model.dart';
import 'package:click_shop/config/app_theme.dart';
import 'package:click_shop/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemCount = ref.watch(cartItemCountProvider);
    final userName = ref.watch(loginViewModelProvider).displayName;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const ProfileDrawer(),
      appBar: _HomeAppBar(cartItemCount: cartItemCount, userName: userName),
      bottomNavigationBar: const BottomNavBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = (constraints.maxWidth * 0.045).clamp(
            18.0,
            40.0,
          );

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12,
              horizontalPadding,
              28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const HomeSlider(),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Categories',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.darkGreen,
                          ),
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    const CategoryView(),
                    const SizedBox(height: 18),
                    const ProductListingView(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({required this.cartItemCount, required this.userName});

  final int cartItemCount;
  final String userName;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = (constraints.maxWidth * 0.045).clamp(
              18.0,
              40.0,
            );
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: _TopActions(
                    cartItemCount: cartItemCount,
                    userName: userName,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TopActions extends StatelessWidget {
  const _TopActions({required this.cartItemCount, required this.userName});

  final int cartItemCount;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Welcome $userName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'What are you shopping today?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        Stack(
          clipBehavior: Clip.none,
          children: [
            _HeaderIcon(
              icon: Icons.shopping_cart_outlined,
              onPressed: () => context.push(AppRoutes.cart),
            ),
            if (cartItemCount > 0)
              Positioned(
                right: 0,
                top: -2,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    cartItemCount > 99 ? '99+' : '$cartItemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      padding: const EdgeInsets.all(7),
      icon: Icon(
        icon,
        size: 26,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
