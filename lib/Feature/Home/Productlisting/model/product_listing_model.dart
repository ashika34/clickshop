class ProductListingModel {
  const ProductListingModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  factory ProductListingModel.fromJson(Map<String, dynamic> json) {
    final products = json['products'] as List<dynamic>? ?? const [];
    return ProductListingModel(
      products: products
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList(growable: false),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}

class ProductModel {
  const ProductModel({
    required this.id,
    required this.brand,
    required this.title,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.reviewCount,
  });

  final int id;
  final String brand;
  final String title;
  final double price;
  final double rating;
  final String thumbnail;
  final int reviewCount;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      brand: json['brand'] as String? ?? 'Unbranded',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
      reviewCount: (json['reviews'] as List<dynamic>?)?.length ?? 0,
    );
  }
}
