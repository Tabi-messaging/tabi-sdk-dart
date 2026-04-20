# Example: list channels

This folder is what pub.dev uses for the **Example** tab.

Run with a real API key (workspace or channel key from the Tabi dashboard):

```bash
dart run example/basic_example.dart --define=TABI_API_KEY=tk_your_key_here
```

The script calls `TabiClient.channels().list()` and prints the JSON response.

For a full integration guide (sending messages, OTP, webhooks, every method), see the
[package README](https://pub.dev/packages/tabi_sdk) on pub.dev.
