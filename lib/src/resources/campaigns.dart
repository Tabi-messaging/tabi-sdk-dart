import '../tabi_http_client.dart';

class Campaigns {
  Campaigns(this._http);
  final TabiHttpClient _http;

  Future<dynamic> create(Map<String, dynamic> data) =>
      _http.post('/campaigns', data);

  Future<dynamic> list([Map<String, dynamic>? query]) =>
      _http.get('/campaigns', query);

  Future<dynamic> get(String id) => _http.get('/campaigns/$id');

  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _http.patch('/campaigns/$id', data);

  Future<dynamic> delete(String id) => _http.delete('/campaigns/$id');

  Future<dynamic> schedule(String id) =>
      _http.post('/campaigns/$id/schedule');

  Future<dynamic> pause(String id) => _http.post('/campaigns/$id/pause');

  Future<dynamic> resume(String id) => _http.post('/campaigns/$id/resume');

  Future<dynamic> cancel(String id) => _http.post('/campaigns/$id/cancel');
}
