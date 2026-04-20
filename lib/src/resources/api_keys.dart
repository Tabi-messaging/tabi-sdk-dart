import '../tabi_http_client.dart';

/// API keys (create typically requires a user JWT, not a channel key) (`/api-keys/*`).
class ApiKeys {
  ApiKeys(this._http);
  final TabiHttpClient _http;

  Future<dynamic> create(Map<String, dynamic> data) =>
      _http.post('/api-keys', data);

  Future<dynamic> list([Map<String, dynamic>? query]) =>
      _http.get('/api-keys', query);

  Future<dynamic> revoke(String id) => _http.post('/api-keys/$id/revoke');

  Future<dynamic> delete(String id) => _http.delete('/api-keys/$id');
}
