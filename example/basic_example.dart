// ignore_for_file: avoid_print

/// Minimal usage example. Replace the API key with a real workspace or channel key.
///
/// Run from the package root:
///   dart run example/basic_example.dart
library;

import 'package:tabi_sdk/tabi_sdk.dart';

Future<void> main() async {
  const apiKey = String.fromEnvironment('TABI_API_KEY', defaultValue: '');
  if (apiKey.isEmpty) {
    print('Set TABI_API_KEY, e.g.: dart run example/basic_example.dart '
        '--define=TABI_API_KEY=your_key');
    return;
  }

  final client = TabiClient(apiKey);
  final channels = await client.channels().list();
  print(channels);
}
