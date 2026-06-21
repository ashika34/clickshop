import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailUiState {
  const ProductDetailUiState({this.selectedImage = 0, this.isFavorite = false});

  final int selectedImage;
  final bool isFavorite;

  ProductDetailUiState copyWith({int? selectedImage, bool? isFavorite}) {
    return ProductDetailUiState(
      selectedImage: selectedImage ?? this.selectedImage,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final productDetailUiProvider =
    NotifierProvider.autoDispose<ProductDetailViewModel, ProductDetailUiState>(
      ProductDetailViewModel.new,
    );

class ProductDetailViewModel extends Notifier<ProductDetailUiState> {
  @override
  ProductDetailUiState build() => const ProductDetailUiState();

  void selectImage(int index) {
    if (state.selectedImage != index) {
      state = state.copyWith(selectedImage: index);
    }
  }

  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }
}
