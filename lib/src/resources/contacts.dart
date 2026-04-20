import '../tabi_http_client.dart';

class Contacts {
  Contacts(this._http);
  final TabiHttpClient _http;

  Future<dynamic> create(Map<String, dynamic> data) =>
      _http.post('/contacts', data);

  Future<dynamic> list([Map<String, dynamic>? query]) =>
      _http.get('/contacts', query);

  Future<dynamic> get(String id) => _http.get('/contacts/$id');

  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _http.patch('/contacts/$id', data);

  Future<dynamic> delete(String id) => _http.delete('/contacts/$id');

  Future<dynamic> import(Map<String, dynamic> data) =>
      _http.post('/contacts/import', data);

  Future<dynamic> getTags(String id) => _http.get('/contacts/$id/tags');

  Future<dynamic> addTag(String id, String tag) =>
      _http.post('/contacts/$id/tags', {'tag': tag});

  Future<dynamic> removeTag(String id, String tag) =>
      _http.delete('/contacts/$id/tags/${Uri.encodeComponent(tag)}');

  Future<dynamic> optIn(String id) => _http.post('/contacts/$id/opt-in');

  Future<dynamic> optOut(String id) => _http.post('/contacts/$id/opt-out');
}
