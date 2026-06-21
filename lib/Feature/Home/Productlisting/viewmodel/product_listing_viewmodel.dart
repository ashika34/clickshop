import 'package:click_shop/Feature/Home/Productlisting/model/product_listing_model.dart';
import 'package:click_shop/Feature/Home/Productlisting/repository/product_listing_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productListingViewModelProvider =
    AsyncNotifierProvider.autoDispose<
      ProductListingViewModel,
      List<ProductModel>
    >(ProductListingViewModel.new);

class ProductListingViewModel extends AsyncNotifier<List<ProductModel>> {
  @override
  Future<List<ProductModel>> build() {
    return ref.read(productListingRepositoryProvider).fetchProducts();
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      ref.read(productListingRepositoryProvider).fetchProducts,
    );
  }
}
