import '../tabi_http_client.dart';

class AutomationInstalls {
  AutomationInstalls(this._http);
  final TabiHttpClient _http;

  Future<dynamic> install(Map<String, dynamic> data) =>
      _http.post('/automation-installs', data);

  Future<dynamic> list() => _http.get('/automation-installs');

  Future<dynamic> get(String id) => _http.get('/automation-installs/$id');

  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _http.patch('/automation-installs/$id', data);

  Future<dynamic> enable(String id) =>
      _http.post('/automation-installs/$id/enable');

  Future<dynamic> disable(String id) =>
      _http.post('/automation-installs/$id/disable');

  Future<dynamic> uninstall(String id) =>
      _http.delete('/automation-installs/$id');
}
