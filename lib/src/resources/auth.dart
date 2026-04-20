import '../tabi_http_client.dart';

/// Authentication: login, register, refresh, session (`/auth/*`).
class Auth {
  Auth(this._http);
  final TabiHttpClient _http;

  Future<dynamic> login(String email, String password) =>
      _http.post('/auth/login', {'email': email, 'password': password});

  Future<dynamic> register(Map<String, dynamic> data) =>
      _http.post('/auth/register', data);

  Future<dynamic> refresh(String refreshToken) =>
      _http.post('/auth/refresh', {'refreshToken': refreshToken});

  Future<dynamic> logout() => _http.post('/auth/logout');

  Future<dynamic> me() => _http.get('/auth/me');

  Future<dynamic> invitePreview(String token) =>
      _http.get('/auth/invite-preview', {'token': token});
}
