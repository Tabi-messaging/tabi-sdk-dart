# tabi_sdk

Official **Dart / Flutter** client for the [Tabi](https://tabi.africa) WhatsApp Business Messaging API. The API surface mirrors the PHP package [`tabi/sdk`](https://packagist.org/packages/tabi/sdk): same `TabiClient` entry point and resource groups.

**Source repository:** [github.com/Tabi-messaging/tabi-sdk-dart](https://github.com/Tabi-messaging/tabi-sdk-dart)

## Requirements

- Dart SDK **>= 3.0.0** (Flutter projects use the same constraint in `pubspec.yaml`).

## Installation

From [pub.dev](https://pub.dev/packages/tabi_sdk) (after publish):

```yaml
dependencies:
  tabi_sdk: ^0.1.0
```

From Git:

```yaml
dependencies:
  tabi_sdk:
    git:
      url: https://github.com/Tabi-messaging/tabi-sdk-dart.git
      ref: main
```

Run `dart pub get`.

## Quick start

```dart
import 'package:tabi_sdk/tabi_sdk.dart';

void main() async {
  final client = TabiClient('YOUR_API_KEY');

  final channels = await client.channels().list();
  print(channels);
}
```

Default base URL is `https://api.tabi.africa/api/v1`. Override when needed:

```dart
final client = TabiClient(
  'YOUR_API_KEY',
  baseUrl: 'https://api.tabi.africa/api/v1',
);
```

Use a **workspace or channel API key**, or a **user JWT** when an endpoint requires it. See [API docs](https://tabi.africa/api-docs).

## API surface

| Resource | Method on `TabiClient` |
|----------|-------------------------|
| Auth | `auth()` |
| Channels | `channels()` |
| Messages | `messages()` |
| Contacts | `contacts()` |
| Conversations | `conversations()` |
| Webhooks | `webhooks()` |
| API keys | `apiKeys()` |
| Files | `files()` |
| Campaigns | `campaigns()` |
| Automation templates | `automationTemplates()` |
| Automation installs | `automationInstalls()` |
| Quick replies | `quickReplies()` |
| Analytics | `analytics()` |
| Notifications | `notifications()` |
| Integrations | `integrations()` |
| Workspaces | `workspaces()` |

## Errors

Failed HTTP calls throw [`TabiException`](lib/src/tabi_exception.dart): `message`, optional `statusCode`, and raw `body` when the server returned JSON.

## Testing

Inject a custom [`TabiHttpClient`](lib/src/tabi_http_client.dart) (for example with a `Dio` instance that uses a stub `HttpClientAdapter`) via [`TabiClient.withHttp`](lib/src/tabi_client.dart). See `test/tabi_http_client_test.dart`.

## Live smoke check (optional)

From the repository root, with real credentials (do not commit secrets):

```bash
export TABI_API_KEY=your_key
# optional:
# export TABI_BASE_URL=https://api.tabi.africa/api/v1

dart run tool/smoke.dart
```

The script lists channels and prints JSON or a clear error.

## Development

```bash
git clone https://github.com/Tabi-messaging/tabi-sdk-dart.git
cd tabi-sdk-dart
dart pub get
dart analyze
dart test
```

CI runs `dart pub get`, `dart analyze`, and `dart test` on push and pull requests.

## Publishing (maintainers)

See [PUBLISHING.md](PUBLISHING.md).

## License

MIT — see [LICENSE](LICENSE).
