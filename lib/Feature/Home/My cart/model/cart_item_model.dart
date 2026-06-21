import 'package:click_shop/Feature/Home/Productdetail/model/product_details_model.dart';

class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
  });

  final int id;
  final String name;
  final String brand;
  final double price;
  final String image;

  factory CartItemModel.fromProduct(ProductDetailsModel product) {
    return CartItemModel(
      id: product.id,
      name: product.title,
      brand: product.brand,
      price: product.price,
      image: product.thumbnail.isNotEmpty
          ? product.thumbnail
          : (product.galleryImages.isEmpty ? '' : product.galleryImages.first),
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'brand': brand,
    'price': price,
    'image': image,
  };
}
