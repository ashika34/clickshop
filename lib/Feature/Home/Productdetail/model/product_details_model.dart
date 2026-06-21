class ProductDetailsModel {
  const ProductDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final double weight;
  final ProductDimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ProductReview> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final ProductMeta meta;
  final List<String> images;
  final String thumbnail;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      brand: json['brand'] as String? ?? 'Unbranded',
      sku: json['sku'] as String? ?? 'N/A',
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      dimensions: ProductDimensions.fromJson(
        json['dimensions'] as Map<String, dynamic>? ?? const {},
      ),
      warrantyInformation: json['warrantyInformation'] as String? ?? 'N/A',
      shippingInformation: json['shippingInformation'] as String? ?? 'N/A',
      availabilityStatus: json['availabilityStatus'] as String? ?? 'N/A',
      reviews: (json['reviews'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProductReview.fromJson)
          .toList(growable: false),
      returnPolicy: json['returnPolicy'] as String? ?? 'N/A',
      minimumOrderQuantity: json['minimumOrderQuantity'] as int? ?? 0,
      meta: ProductMeta.fromJson(
        json['meta'] as Map<String, dynamic>? ?? const {},
      ),
      images: (json['images'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  List<String> get galleryImages {
    final values = <String>{...images};
    if (thumbnail.isNotEmpty) values.add(thumbnail);
    return values.toList(growable: false);
  }

  double get originalPrice {
    final discount = discountPercentage / 100;
    return discount >= 1 ? price : price / (1 - discount);
  }
}

class ProductDimensions {
  const ProductDimensions({
    required this.width,
    required this.height,
    required this.depth,
  });
  final double width;
  final double height;
  final double depth;

  factory ProductDimensions.fromJson(Map<String, dynamic> json) {
    return ProductDimensions(
      width: (json['width'] as num?)?.toDouble() ?? 0,
      height: (json['height'] as num?)?.toDouble() ?? 0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0,
    );
  }
}

class ProductReview {
  const ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });
  final int rating;
  final String comment;
  final DateTime? date;
  final String reviewerName;
  final String reviewerEmail;

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? ''),
      reviewerName: json['reviewerName'] as String? ?? '',
      reviewerEmail: json['reviewerEmail'] as String? ?? '',
    );
  }
}

class ProductMeta {
  const ProductMeta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String barcode;
  final String qrCode;

  factory ProductMeta.fromJson(Map<String, dynamic> json) {
    return ProductMeta(
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      barcode: json['barcode'] as String? ?? 'N/A',
      qrCode: json['qrCode'] as String? ?? '',
    );
  }
}
