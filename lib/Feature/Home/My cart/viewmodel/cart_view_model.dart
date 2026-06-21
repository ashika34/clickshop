import 'dart:async';

import 'package:click_shop/Feature/Home/My cart/model/cart_item_model.dart';
import 'package:click_shop/Feature/Home/Productdetail/model/product_details_model.dart';
import 'package:click_shop/core/storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartViewModelProvider =
    NotifierProvider<CartViewModel, List<CartItemModel>>(CartViewModel.new);

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartViewModelProvider).length;
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref
      .watch(cartViewModelProvider)
      .fold(0, (total, item) => total + item.price);
});

class CartViewModel extends Notifier<List<CartItemModel>> {
  @override
  List<CartItemModel> build() {
    return ref
        .read(localStorageProvider)
        .readCart()
        .map(CartItemModel.fromJson)
        .toList(growable: false);
  }

  void addProduct(ProductDetailsModel product) {
    state = [...state, CartItemModel.fromProduct(product)];
    _persistCart();
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.length) return;
    final updatedCart = [...state]..removeAt(index);
    state = updatedCart;
    _persistCart();
  }

  void _persistCart() {
    unawaited(
      ref
          .read(localStorageProvider)
          .saveCart(state.map((item) => item.toJson()).toList(growable: false)),
    );
  }
}
