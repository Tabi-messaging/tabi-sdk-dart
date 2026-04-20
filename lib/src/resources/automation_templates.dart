import '../tabi_http_client.dart';

/// Automation template catalog (`/automation-templates/*`).
class AutomationTemplates {
  AutomationTemplates(this._http);
  final TabiHttpClient _http;

  Future<dynamic> list() => _http.get('/automation-templates');

  Future<dynamic> get(String id) => _http.get('/automation-templates/$id');
}
