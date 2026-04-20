import '../tabi_http_client.dart';

class Conversations {
  Conversations(this._http);
  final TabiHttpClient _http;

  Future<dynamic> list([Map<String, dynamic>? query]) =>
      _http.get('/conversations', query);

  Future<dynamic> get(String id) => _http.get('/conversations/$id');

  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _http.patch('/conversations/$id', data);

  Future<dynamic> resolve(String id) =>
      _http.post('/conversations/$id/resolve');

  Future<dynamic> reopen(String id) =>
      _http.post('/conversations/$id/reopen');

  Future<dynamic> markRead(String id) =>
      _http.post('/conversations/$id/read');
}
