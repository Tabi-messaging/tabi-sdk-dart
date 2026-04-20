/// Thrown when the Tabi API returns an error response or the request fails.
class TabiException implements Exception {
  TabiException(this.message, this.statusCode, [this.body]);

  final String message;
  final int statusCode;
  final Object? body;

  @override
  String toString() => 'TabiException($statusCode): $message';
}
