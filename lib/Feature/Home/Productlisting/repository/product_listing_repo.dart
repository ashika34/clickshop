import 'package:click_shop/Feature/Home/Productlisting/model/product_listing_model.dart';
import 'package:click_shop/core/api_service.dart';
import 'package:click_shop/core/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productListingRepositoryProvider = Provider<ProductListingRepository>((
  ref,
) {
  return ProductListingRepository(ApiService());
});

class ProductListingRepository {
  const ProductListingRepository(this._apiService);

  final ApiService _apiService;

  Future<List<ProductModel>> fetchProducts() async {
    final data = await _apiService.get(AppConstants.products);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid products response');
    }

    return ProductListingModel.fromJson(data).products;
  }
}
