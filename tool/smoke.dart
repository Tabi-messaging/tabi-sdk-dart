// ignore_for_file: avoid_print

/// Optional live smoke test against the Tabi API (VM / desktop / CI with secrets).
///
/// Usage:
///   export TABI_API_KEY=...
///   dart run tool/smoke.dart
///
/// Optional:
///   export TABI_BASE_URL=https://api.tabi.africa/api/v1
library;

import 'dart:io';

import 'package:tabi_sdk/tabi_sdk.dart';

Future<void> main() async {
  final apiKey = Platform.environment['TABI_API_KEY']?.trim() ?? '';
  if (apiKey.isEmpty) {
    stderr.writeln(
      'Missing TABI_API_KEY. Example: export TABI_API_KEY=your_key',
    );
    exitCode = 1;
    return;
  }

  final baseUrl = Platform.environment['TABI_BASE_URL']?.trim();
  final client = baseUrl != null && baseUrl.isNotEmpty
      ? TabiClient(apiKey, baseUrl: baseUrl)
      : TabiClient(apiKey);

  try {
    final data = await client.channels().list();
    stdout.writeln(data);
  } on TabiException catch (e) {
    stderr.writeln('TabiException: ${e.message} (${e.statusCode})');
    if (e.body != null) {
      stderr.writeln(e.body);
    }
    exitCode = 1;
  } catch (e, st) {
    stderr.writeln(e);
    stderr.writeln(st);
    exitCode = 1;
  }
}
