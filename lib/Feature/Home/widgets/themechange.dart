import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawerDarkModeProvider = NotifierProvider<DrawerDarkModeController, bool>(
  DrawerDarkModeController.new,
);

class DrawerDarkModeController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle(bool enabled) => state = enabled;
}
