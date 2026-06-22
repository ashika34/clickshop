import 'package:click_shop/Feature/Home/Productdetail/model/product_details_model.dart';

class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  final int id;
  final String name;
  final String brand;
  final double price;
  final String image;
  final int quantity;

  factory CartItemModel.fromProduct(ProductDetailsModel product) {
    return CartItemModel(
      id: product.id,
      name: product.title,
      brand: product.brand,
      price: product.price,
      image: product.thumbnail.isNotEmpty
          ? product.thumbnail
          : (product.galleryImages.isEmpty ? '' : product.galleryImages.first),
      quantity: 1,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      image: json['image'] as String? ?? '',
      quantity: ((json['quantity'] as num?)?.toInt() ?? 1).clamp(1, 9999),
    );
  }

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      id: id,
      name: name,
      brand: brand,
      price: price,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'brand': brand,
    'price': price,
    'image': image,
    'quantity': quantity,
  };
}
