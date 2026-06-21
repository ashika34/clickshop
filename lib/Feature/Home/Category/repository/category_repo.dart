import 'package:click_shop/Feature/Home/Category/model/category_model.dart';
import 'package:click_shop/core/api_service.dart';
import 'package:click_shop/core/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ApiService());
});

class CategoryRepository {
  const CategoryRepository(this._apiService);

  final ApiService _apiService;

  Future<List<CategoryModel>> fetchCategories() async {
    final data = await _apiService.get(AppConstants.productCategories);
    if (data is! List) {
      throw const FormatException('Invalid categories response');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(CategoryModel.fromJson)
        .where((category) => category.name.isNotEmpty)
        .toList(growable: false);
  }
}
