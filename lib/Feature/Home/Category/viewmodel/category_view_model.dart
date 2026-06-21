import 'package:click_shop/Feature/Home/Category/model/category_model.dart';
import 'package:click_shop/Feature/Home/Category/repository/category_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryViewModelProvider =
    AsyncNotifierProvider.autoDispose<CategoryViewModel, List<CategoryModel>>(
      CategoryViewModel.new,
    );

class CategoryViewModel extends AsyncNotifier<List<CategoryModel>> {
  @override
  Future<List<CategoryModel>> build() {
    return ref.read(categoryRepositoryProvider).fetchCategories();
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      ref.read(categoryRepositoryProvider).fetchCategories,
    );
  }
}
