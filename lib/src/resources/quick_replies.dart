import '../tabi_http_client.dart';

/// Canned replies / shortcuts (`/quick-replies/*`).
class QuickReplies {
  QuickReplies(this._http);
  final TabiHttpClient _http;

  Future<dynamic> list() => _http.get('/quick-replies');

  Future<dynamic> create(Map<String, dynamic> data) =>
      _http.post('/quick-replies', data);

  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _http.patch('/quick-replies/$id', data);

  Future<dynamic> delete(String id) => _http.delete('/quick-replies/$id');
}
