import 'package:click_shop/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavIndexProvider =
    NotifierProvider.autoDispose<BottomNavController, int>(
      BottomNavController.new,
    );

class BottomNavController extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) {
    if (state != index) state = index;
  }
}

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);
    final compact = MediaQuery.sizeOf(context).width < 360;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        ref.read(bottomNavIndexProvider.notifier).select(index);
        if (index == 3) Scaffold.of(context).openDrawer();
      },
      height: 72,
      backgroundColor: Theme.of(context).colorScheme.surface,
      indicatorColor: AppColors.lightGreen.withValues(alpha: 0.18),
      labelBehavior: compact
          ? NavigationDestinationLabelBehavior.onlyShowSelected
          : NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded, color: AppColors.darkGreen),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(
            Icons.grid_view_rounded,
            color: AppColors.darkGreen,
          ),
          label: 'Categories',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(
            Icons.receipt_long_rounded,
            color: AppColors.darkGreen,
          ),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded, color: AppColors.darkGreen),
          label: 'Profile',
        ),
      ],
    );
  }
}
