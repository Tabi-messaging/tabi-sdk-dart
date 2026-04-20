import '../tabi_http_client.dart';

/// Analytics dashboards and breakdowns (`/analytics/*`).
class Analytics {
  Analytics(this._http);
  final TabiHttpClient _http;

  Future<dynamic> dashboard([Map<String, dynamic>? query]) =>
      _http.get('/analytics/dashboard', query);

  Future<dynamic> channels([Map<String, dynamic>? query]) =>
      _http.get('/analytics/channels', query);

  Future<dynamic> conversations([Map<String, dynamic>? query]) =>
      _http.get('/analytics/conversations', query);
}
