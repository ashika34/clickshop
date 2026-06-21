import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  return const LocalStorage.inMemory();
});

class LocalStorage {
  const LocalStorage(this._preferences);
  const LocalStorage.inMemory() : _preferences = null;

  static const _cartKey = 'cart_items';

  final SharedPreferences? _preferences;

  List<Map<String, dynamic>> readCart() {
    final savedCart = _preferences?.getString(_cartKey);
    if (savedCart == null || savedCart.isEmpty) return const [];

    try {
      final decoded = jsonDecode(savedCart) as List<dynamic>;
      return decoded.whereType<Map<String, dynamic>>().toList(growable: false);
    } on FormatException {
      return const [];
    }
  }

  Future<void> saveCart(List<Map<String, dynamic>> items) async {
    await _preferences?.setString(_cartKey, jsonEncode(items));
  }
}
