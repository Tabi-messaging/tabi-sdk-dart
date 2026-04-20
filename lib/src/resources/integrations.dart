import '../tabi_http_client.dart';

class Integrations {
  Integrations(this._http);
  final TabiHttpClient _http;

  Future<dynamic> listProviders() =>
      _http.get('/integrations/providers');

  Future<dynamic> create(Map<String, dynamic> data) =>
      _http.post('/integrations', data);

  Future<dynamic> list() => _http.get('/integrations');

  Future<dynamic> get(String id) => _http.get('/integrations/$id');

  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _http.patch('/integrations/$id', data);

  Future<dynamic> delete(String id) => _http.delete('/integrations/$id');

  Future<dynamic> test(String id) => _http.post('/integrations/$id/test');
}
