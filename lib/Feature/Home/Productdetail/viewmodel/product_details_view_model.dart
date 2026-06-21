import 'package:click_shop/Feature/Home/Productdetail/model/product_details_model.dart';
import 'package:click_shop/Feature/Home/Productdetail/repository/product_detail_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productDetailsViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<ProductDetailsViewModel, ProductDetailsModel, int>(
      ProductDetailsViewModel.new,
    );

class ProductDetailsViewModel extends AsyncNotifier<ProductDetailsModel> {
  ProductDetailsViewModel(this.productId);
  final int productId;

  @override
  Future<ProductDetailsModel> build() {
    return ref
        .read(productDetailsRepositoryProvider)
        .fetchProductDetails(productId);
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(productDetailsRepositoryProvider)
          .fetchProductDetails(productId),
    );
  }
}
