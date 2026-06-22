import 'package:click_shop/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortestSide = constraints.biggest.shortestSide;
            final animationSize = (shortestSide * 0.72).clamp(220.0, 520.0);

            return Center(
              child: SizedBox.square(
                dimension: animationSize,
                child: Lottie.asset(
                  'assets/lotties/Order success.json',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  repeat: true,
                  animate: true,
                  frameRate: FrameRate.max,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
