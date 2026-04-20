import '../tabi_http_client.dart';

class Webhooks {
  Webhooks(this._http);
  final TabiHttpClient _http;

  Future<dynamic> create(Map<String, dynamic> data) =>
      _http.post('/webhooks', data);

  Future<dynamic> list([Map<String, dynamic>? query]) =>
      _http.get('/webhooks', query);

  Future<dynamic> get(String id) => _http.get('/webhooks/$id');

  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _http.patch('/webhooks/$id', data);

  Future<dynamic> delete(String id) => _http.delete('/webhooks/$id');

  Future<dynamic> ping(String id) => _http.post('/webhooks/$id/ping');

  Future<dynamic> rotateSecret(String id) =>
      _http.post('/webhooks/$id/rotate-secret');

  Future<dynamic> deliveryLogs([Map<String, dynamic>? query]) =>
      _http.get('/webhooks/delivery-logs', query);

  Future<dynamic> startTestCapture(Map<String, dynamic> data) =>
      _http.post('/webhooks/test-capture/start', data);

  Future<dynamic> stopTestCapture(Map<String, dynamic> data) =>
      _http.post('/webhooks/test-capture/stop', data);

  Future<dynamic> testCaptureStatus(Map<String, dynamic> query) =>
      _http.get('/webhooks/test-capture/status', query);
}
