import 'package:click_shop/core/app_constants.dart';
import 'package:dio/dio.dart';

class ApiService {
  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConstants.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  final Dio _dio;

  Future<dynamic> get(String endpoint) async {
    final response = await _dio.get<dynamic>(endpoint);
    return response.data;
  }
}
