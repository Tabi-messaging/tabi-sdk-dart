import '../tabi_http_client.dart';

/// Workspaces and members (`/workspaces/*`).
class Workspaces {
  Workspaces(this._http);
  final TabiHttpClient _http;

  Future<dynamic> create(Map<String, dynamic> data) =>
      _http.post('/workspaces', data);

  Future<dynamic> list() => _http.get('/workspaces');

  Future<dynamic> get(String id) => _http.get('/workspaces/$id');

  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _http.patch('/workspaces/$id', data);

  Future<dynamic> listMembers(String id) =>
      _http.get('/workspaces/$id/members');

  Future<dynamic> inviteMember(String id, Map<String, dynamic> data) =>
      _http.post('/workspaces/$id/members/invite', data);
}
