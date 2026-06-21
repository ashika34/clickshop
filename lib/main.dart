import 'package:click_shop/config/app_route.dart';
import 'package:click_shop/config/app_theme.dart';
import 'package:click_shop/core/storage.dart';
import 'package:click_shop/Feature/Home/widgets/themechange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(LocalStorage(preferences)),
      ],
      child: const ClickShopApp(),
    ),
  );
}

class ClickShopApp extends ConsumerWidget {
  const ClickShopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(drawerDarkModeProvider);

    return MaterialApp.router(
      title: 'Click Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: const Duration(milliseconds: 300),
      themeAnimationCurve: Curves.easeInOut,
      routerConfig: appRouter,
    );
  }
}
