import '../tabi_http_client.dart';

class Notifications {
  Notifications(this._http);
  final TabiHttpClient _http;

  Future<dynamic> list([Map<String, dynamic>? query]) =>
      _http.get('/notifications', query);

  Future<dynamic> markRead(String id) =>
      _http.patch('/notifications/$id/read');

  Future<dynamic> markAllRead() =>
      _http.post('/notifications/read-all');

  Future<dynamic> unreadCount() =>
      _http.get('/notifications/unread-count');
}
