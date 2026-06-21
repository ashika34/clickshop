import 'package:click_shop/Feature/Splashscreen/viewmodel/splash_view_model.dart';
import 'package:click_shop/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(splashViewModelProvider.notifier).startAnimation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashViewModelProvider, (previous, next) {
      if (next.isComplete && previous?.isComplete != true && mounted) {
        context.go(AppRoutes.login);
      }
    });

    final splashState = ref.watch(splashViewModelProvider);

    return Scaffold(
      // The logo asset has a white canvas. Keep the splash background exactly
      // white so its rectangular image boundary does not show in tinted themes.
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final shortestSide = constraints.biggest.shortestSide;
          final logoSize = (shortestSide * 0.42).clamp(0.0, 320.0);

          return Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.04,
                end: splashState.isAnimating || splashState.isComplete
                    ? 1.15
                    : 0.04,
              ),
              duration: splashAnimationDuration,
              curve: Curves.easeInOutCubic,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Image.asset(
                'assets/images/logo.png',
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
                semanticLabel: 'Click Shop logo',
              ),
            ),
          );
        },
      ),
    );
  }
}
