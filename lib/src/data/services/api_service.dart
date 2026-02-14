import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutcn_ui/src/core/errors/exceptions.dart';
import 'package:flutcn_ui/src/core/services/api_service.dart';
import 'package:http/http.dart' as http;

class HttpServiceImpl extends ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  static const _timeout = Duration(seconds: 30);

  HttpServiceImpl({
    required this.baseUrl,
    this.defaultHeaders = const {
      "Content-Type": "application/json",
    },
  });

  @override
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _withErrorHandling(
      () => http.get(uri, headers: {...defaultHeaders, ...?headers}),
    );
    return _httpToApiResponse(response);
  }

  @override
  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _withErrorHandling(
      () => http.post(
        uri,
        headers: {...defaultHeaders, ...?headers},
        body: jsonEncode(data),
      ),
    );
    return _httpToApiResponse(response);
  }

  @override
  Future<ApiResponse> update(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
    final response = await _withErrorHandling(
      () => http.patch(
        uri,
        headers: {...defaultHeaders, ...?headers},
        body: jsonEncode(data),
      ),
    );
    return _httpToApiResponse(response);
  }

  @override
  Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
    final response = await _withErrorHandling(
      () => http.put(
        uri,
        headers: {...defaultHeaders, ...?headers},
        body: jsonEncode(data),
      ),
    );
    return _httpToApiResponse(response);
  }

  @override
  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
    final response = await _withErrorHandling(
      () => http.delete(uri, headers: {...defaultHeaders, ...?headers}),
    );
    return _httpToApiResponse(response);
  }

  /// Wraps an HTTP call with timeout and offline detection.
  Future<http.Response> _withErrorHandling(
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request().timeout(_timeout);
    } on SocketException {
      throw OfflineException();
    } on http.ClientException {
      // The http package wraps SocketException in ClientException
      // for DNS failures, connection refused, etc.
      throw OfflineException();
    } on TimeoutException {
      throw ServerException(
          message: 'Request timed out after ${_timeout.inSeconds} seconds');
    }
  }

  ApiResponse _httpToApiResponse(http.Response response) {
    dynamic data;
    final contentType = response.headers['content-type'];

    if (contentType?.contains('application/json') == true) {
      data = jsonDecode(response.body);
    } else {
      data = response.body;
    }

    return ApiResponse(
      data,
      response.statusCode,
      response.reasonPhrase,
    );
  }
}
