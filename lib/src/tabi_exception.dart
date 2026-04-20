/// Thrown when the Tabi API returns an error response or the HTTP request fails.
///
/// [statusCode] is the HTTP status (0 if no response). [body] is the decoded JSON
/// error payload when the server returned JSON.
class TabiException implements Exception {
  TabiException(this.message, this.statusCode, [this.body]);

  final String message;
  final int statusCode;
  final Object? body;

  @override
  String toString() => 'TabiException($statusCode): $message';
}
