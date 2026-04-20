import '../tabi_http_client.dart';

class Channels {
  Channels(this._http);
  final TabiHttpClient _http;

  Future<dynamic> create(Map<String, dynamic> data) =>
      _http.post('/channels', data);

  Future<dynamic> list() => _http.get('/channels');

  Future<dynamic> get(String id) => _http.get('/channels/$id');

  Future<dynamic> connect(String id, [Map<String, dynamic>? data]) =>
      _http.post('/channels/$id/connect', data);

  Future<dynamic> disconnect(String id) =>
      _http.post('/channels/$id/disconnect');

  Future<dynamic> status(String id) => _http.get('/channels/$id/status');

  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _http.patch('/channels/$id', data);

  Future<dynamic> reconnect(String id) =>
      _http.post('/channels/$id/reconnect');

  Future<dynamic> delete(String id) => _http.delete('/channels/$id');

  Future<dynamic> sendOtp(String id, Map<String, dynamic> data) =>
      _http.post('/channels/$id/otp/send', data);

  Future<dynamic> verifyOtp(String id, Map<String, dynamic> data) =>
      _http.post('/channels/$id/otp/verify', data);
}
