import 'package:click_shop/Feature/Checkout/view/checkout_view.dart';
import 'package:click_shop/Feature/Home/My cart/view/my_cart.dart';
import 'package:click_shop/Feature/Home/home_view.dart';
import 'package:click_shop/Feature/Home/Productdetail/view/product_detail_view.dart';
import 'package:click_shop/Feature/LoginScreen/View/login_view.dart';
import 'package:click_shop/Feature/Splashscreen/View/splashview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const productDetail = '/product/:id';

  static String productDetailPath(int id) => '/product/$id';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 500),
        child: const LoginView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 400),
        child: const CheckoutView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1).animate(animation),
              child: child,
            ),
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.cart,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        child: const MyCart(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.productDetail,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 400),
        child: ProductDetailView(
          productId: int.tryParse(state.pathParameters['id'] ?? '') ?? 1,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 600),
        child: const HomeView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    ),
  ],
);
