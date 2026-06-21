abstract final class AppConstants {
  static const baseUrl = 'https://dummyjson.com';
  static const productCategories = '/products/categories';
  static const products = '/products';

  static String productDetails(int id) => '/products/$id';
}
