import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:tabi_sdk/tabi_sdk.dart';
import 'package:test/test.dart';

/// Minimal Dio [HttpClientAdapter] for unit tests (no outbound network).
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this._handler);
  final ResponseBody Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async =>
      _handler(options);
}

void main() {
  group('TabiHttpClient', () {
    test('unwraps success envelope to data', () {
      expect(
        TabiHttpClient.unwrapEnvelope({
          'success': true,
          'data': {'id': 'x'},
        }),
        {'id': 'x'},
      );
    });

    test('GET returns unwrapped list', () async {
      final dio = Dio(
        BaseOptions(baseUrl: 'https://api.tabi.africa/api/v1'),
      );
      dio.httpClientAdapter = _StubAdapter((RequestOptions options) {
        expect(options.path, '/channels');
        return ResponseBody.fromString(
          jsonEncode(<String, dynamic>{
            'success': true,
            'data': <dynamic>[],
          }),
          200,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>['application/json'],
          },
        );
      });

      final http = TabiHttpClient.withDio(dio);
      final out = await http.get('/channels');
      expect(out, isEmpty);
    });

    test('maps 400 to TabiException with message', () async {
      final dio = Dio(
        BaseOptions(baseUrl: 'https://api.tabi.africa/api/v1'),
      );
      dio.httpClientAdapter = _StubAdapter((RequestOptions options) {
        return ResponseBody.fromString(
          jsonEncode(<String, dynamic>{
            'success': false,
            'message': 'Bad payload',
          }),
          400,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>['application/json'],
          },
        );
      });

      final http = TabiHttpClient.withDio(dio);
      await expectLater(
        http.post('/channels/c/send', <String, dynamic>{}),
        throwsA(
          isA<TabiException>().having(
            (TabiException e) => e.statusCode,
            'statusCode',
            400,
          ).having(
            (TabiException e) => e.message,
            'message',
            'Bad payload',
          ),
        ),
      );
    });
  });

  group('TabiClient', () {
    test('channels list uses same http stack', () async {
      final dio = Dio(
        BaseOptions(baseUrl: 'https://api.tabi.africa/api/v1'),
      );
      dio.httpClientAdapter = _StubAdapter((RequestOptions options) {
        return ResponseBody.fromString(
          jsonEncode(<String, dynamic>{
            'success': true,
            'data': <dynamic>[
              <String, dynamic>{'id': '1', 'name': 'Test'},
            ],
          }),
          200,
          headers: <String, List<String>>{
            Headers.contentTypeHeader: <String>['application/json'],
          },
        );
      });

      final client = TabiClient.withHttp(TabiHttpClient.withDio(dio));
      final out = await client.channels().list();
      expect(out, isA<List<dynamic>>());
      expect((out as List<dynamic>).length, 1);
    });
  });
}
