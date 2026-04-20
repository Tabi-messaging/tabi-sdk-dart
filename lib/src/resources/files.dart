import '../tabi_http_client.dart';

/// Uploaded files: list, metadata, signed URLs (`/files/*`).
class Files {
  Files(this._http);
  final TabiHttpClient _http;

  Future<dynamic> list() => _http.get('/files');

  Future<dynamic> get(String id) => _http.get('/files/$id');

  Future<dynamic> getUrl(String id) => _http.get('/files/$id/url');

  Future<dynamic> delete(String id) => _http.delete('/files/$id');
}
