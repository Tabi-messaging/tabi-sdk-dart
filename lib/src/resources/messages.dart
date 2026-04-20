import '../tabi_http_client.dart';

class Messages {
  Messages(this._http);
  final TabiHttpClient _http;

  Future<dynamic> send(String channelId, Map<String, dynamic> data) =>
      _http.post('/channels/$channelId/send', data);

  Future<dynamic> get(String id) => _http.get('/messages/$id');

  Future<dynamic> listByConversation(
    String conversationId, [
    Map<String, dynamic>? query,
  ]) =>
      _http.get('/conversations/$conversationId/messages', query);

  Future<dynamic> reply(String conversationId, Map<String, dynamic> data) =>
      _http.post('/conversations/$conversationId/messages', data);

  Future<dynamic> sendSticker(String channelId, Map<String, dynamic> data) =>
      _http.post('/channels/$channelId/messaging/sticker', data);

  Future<dynamic> sendContact(String channelId, Map<String, dynamic> data) =>
      _http.post('/channels/$channelId/messaging/contact', data);

  Future<dynamic> sendLocation(String channelId, Map<String, dynamic> data) =>
      _http.post('/channels/$channelId/messaging/location', data);

  Future<dynamic> sendPoll(String channelId, Map<String, dynamic> data) =>
      _http.post('/channels/$channelId/messaging/poll', data);

  Future<dynamic> react(
    String channelId,
    String messageId,
    Map<String, dynamic> data,
  ) =>
      _http.post(
        '/channels/$channelId/messaging/messages/$messageId/reaction',
        data,
      );

  Future<dynamic> markRead(String channelId, String messageId) =>
      _http.post(
        '/channels/$channelId/messaging/messages/$messageId/mark-read',
      );

  Future<dynamic> revoke(String channelId, String messageId) =>
      _http.post(
        '/channels/$channelId/messaging/messages/$messageId/revoke',
      );

  Future<dynamic> edit(
    String channelId,
    String messageId,
    Map<String, dynamic> data,
  ) =>
      _http.post(
        '/channels/$channelId/messaging/messages/$messageId/edit',
        data,
      );

  Future<dynamic> downloadMedia(String channelId, String messageId) =>
      _http.get(
        '/channels/$channelId/messaging/messages/$messageId/media',
      );
}
