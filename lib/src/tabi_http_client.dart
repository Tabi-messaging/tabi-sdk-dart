import 'package:dio/dio.dart';

import 'tabi_exception.dart';

/// Low-level HTTP client: Bearer auth, JSON, unwrap `{ success, data }` envelope.
class TabiHttpClient {
  final Dio _dio;

  TabiHttpClient({
    required String baseUrl,
    required String apiKey,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: _normalizeBaseUrl(baseUrl),
            connectTimeout: connectTimeout ?? const Duration(seconds: 30),
            receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
            headers: <String, dynamic>{
              'Authorization': 'Bearer $apiKey',
              'Accept': 'application/json',
            },
          ),
        );

  /// Test-only: inject a pre-configured [Dio] (e.g. with a mock adapter).
  TabiHttpClient.withDio(this._dio);

  static String _normalizeBaseUrl(String baseUrl) =>
      baseUrl.replaceAll(RegExp(r'/+$'), '');

  /// Visible for tests: unwrap API envelope.
  static dynamic unwrapEnvelope(dynamic json) {
    if (json is Map &&
        json['success'] == true &&
        json.containsKey('data')) {
      return json['data'];
    }
    return json;
  }

  Map<String, dynamic>? _cleanQuery(Map<String, dynamic>? query) {
    if (query == null) return null;
    final out = <String, dynamic>{};
    for (final e in query.entries) {
      if (e.value != null) {
        out[e.key] = e.value;
      }
    }
    return out.isEmpty ? null : out;
  }

  Future<dynamic> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: _cleanQuery(query),
        options: Options(
          method: method,
          headers: body != null
              ? <String, dynamic>{'Content-Type': 'application/json'}
              : null,
        ),
      );
      final data = response.data;
      return unwrapEnvelope(data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  TabiException _mapDioException(DioException e) {
    final status = e.response?.statusCode ?? 0;
    final raw = e.response?.data;
    var msg = 'Request failed ($status)';
    if (raw is Map) {
      final m = raw['message'];
      if (m is String) {
        msg = m;
      } else if (m is List) {
        msg = m.map((x) => x.toString()).join(', ');
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      msg = 'Request timeout';
    } else if (e.message != null && e.message!.isNotEmpty) {
      msg = e.message!;
    }
    return TabiException(msg, status, raw);
  }

  Future<dynamic> get(String path, [Map<String, dynamic>? query]) =>
      request('GET', path, query: query);

  Future<dynamic> post(String path, [Map<String, dynamic>? body]) =>
      request('POST', path, body: body);

  Future<dynamic> patch(String path, [Map<String, dynamic>? body]) =>
      request('PATCH', path, body: body);

  Future<dynamic> delete(String path) => request('DELETE', path);
}
