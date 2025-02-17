class ApiResponse {
  ApiResponse(
    this.body, [
    this.status,
    this.message,
  ]);

  dynamic body;
  int? status;
  String? message;
} 


abstract class ApiService {
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  });

  Future<ApiResponse> update(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });
}