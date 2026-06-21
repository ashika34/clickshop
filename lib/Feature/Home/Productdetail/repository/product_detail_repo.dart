import 'package:click_shop/Feature/Home/Productdetail/model/product_details_model.dart';
import 'package:click_shop/core/api_service.dart';
import 'package:click_shop/core/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productDetailsRepositoryProvider = Provider<ProductDetailsRepository>((
  ref,
) {
  return ProductDetailsRepository(ApiService());
});

class ProductDetailsRepository {
  const ProductDetailsRepository(this._apiService);
  final ApiService _apiService;

  Future<ProductDetailsModel> fetchProductDetails(int id) async {
    final data = await _apiService.get(AppConstants.productDetails(id));
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid product details response');
    }
    return ProductDetailsModel.fromJson(data);
  }
}
