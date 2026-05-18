import 'package:dio/dio.dart';
import '../models/coffee_order.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<CoffeeOrder>> fetchOrders() async {
    try {
      final response = await _dio.get('/posts');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CoffeeOrder.fromJson(json)).toList();
      }
      throw Exception('Server returned status code: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<CoffeeOrder> createOrder(CoffeeOrder order) async {
    try {
      final response = await _dio.post('/posts', data: order.toJson());
      if (response.statusCode == 201) {
        return CoffeeOrder.fromJson(response.data);
      }
      throw Exception('Failed to create item on server.');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<CoffeeOrder> updateOrder(int id, CoffeeOrder order) async {
    try {
      final response = await _dio.put('/posts/$id', data: order.toJson());
      if (response.statusCode == 200) {
        return CoffeeOrder.fromJson(response.data);
      }
      throw Exception('Failed to modify item on server.');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      final response = await _dio.delete('/posts/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete item from server.');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with the server.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to reply.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      default:
        return 'A network anomaly occurred. Please try again.';
    }
  }
}