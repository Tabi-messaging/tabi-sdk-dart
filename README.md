# tabi_sdk (Dart / Flutter)

**Tabi** is a WhatsApp Business messaging platform. This package is the official **Dart / Flutter** client: send messages, manage channels, webhooks, campaigns, and automations using the same JSON bodies as the [PHP](https://packagist.org/packages/tabi/sdk) and [Python](https://pypi.org/project/tabi-sdk/) SDKs.

[![pub package](https://img.shields.io/pub/v/tabi_sdk.svg)](https://pub.dev/packages/tabi_sdk)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/Tabi-messaging/tabi-sdk-dart/blob/main/LICENSE)
[![API docs](https://img.shields.io/badge/API-docs-055799.svg)](https://pub.dev/documentation/tabi_sdk/latest/)

**Links:** [Tabi](https://tabi.africa) · [HTTP / OpenAPI reference](https://tabi.africa/api-docs) · [Repository](https://github.com/Tabi-messaging/tabi-sdk-dart) · [Issue tracker](https://github.com/Tabi-messaging/tabi-sdk-dart/issues) · [Author](#author)

**Search keywords:** WhatsApp API, WhatsApp Business API, messaging, Tabi, Flutter SDK, Dart HTTP client.

## Table of contents

- [Install](#install)
- [Quick start](#quick-start)
- [Configuration](#configuration)
- [Where credentials come from](#where-credentials-come-from)
- [How the client is organised](#how-the-client-is-organised)
- [Request bodies and the full API](#request-bodies-and-the-full-api)
- [Send message body](#send-message-body)
- [Webhook `events`](#webhook-events)
- [OTP over WhatsApp](#otp-over-whatsapp)
- [Resources (all methods)](#resources-all-methods)
- [Error handling](#error-handling)
- [Return values](#return-values)
- [Requirements](#requirements)
- [API documentation (dartdoc)](#api-documentation-dartdoc)
- [Author](#author)
- [Support](#support)
- [Related SDKs](#related-sdks)
- [License](#license)

---

## Install

**pub.dev:**

```yaml
dependencies:
  tabi_sdk: ^0.1.0
```

**Git** (always available):

```yaml
dependencies:
  tabi_sdk:
    git:
      url: https://github.com/Tabi-messaging/tabi-sdk-dart.git
      ref: main
```

Then:

```bash
dart pub get
# or, in a Flutter app:
flutter pub get
```

---

## Quick start

Send a text message from server-side or trusted code using a **workspace or channel API key**:

```dart
import 'package:tabi_sdk/tabi_sdk.dart';

Future<void> main() async {
  final client = TabiClient(
    'tk_your_api_key',
    baseUrl: 'https://api.tabi.africa/api/v1',
  );

  await client.messages().send('your-channel-id', {
    'to': '2348012345678',
    'content': 'Hello from Dart!',
  });
}
```

- **`to`**: digits only, international format, **no** `+` in the JSON value (same as other SDKs).
- **`channel-id`**: from the dashboard (**Channels** → open a channel → ID in the URL or detail view).
- **API key**: create under **Developer → API keys**. Load from environment or a secret store; do **not** embed keys in mobile or browser apps.

---

## Configuration

```dart
import 'package:tabi_sdk/tabi_sdk.dart';

// Resolve `apiKey` from your app: e.g. compile-time defines, env, or a secrets service.
final client = TabiClient(
  apiKey,
  baseUrl: 'https://api.tabi.africa/api/v1',
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
);
```

**Passing the key safely**

- **CLI / tests:** `dart run --dart-define=TABI_API_KEY=tk_...` then `const String.fromEnvironment('TABI_API_KEY')`.
- **Flutter:** [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv), `--dart-define`, or native secure storage—not hard-coded strings in source control.
- **Server / desktop:** `dart:io` `Platform.environment['TABI_API_KEY']` where appropriate.

Default base URL if you omit the second argument: `https://api.tabi.africa/api/v1`.

---

## Where credentials come from

| What | Where to get it |
|------|------------------|
| API key or user JWT | Dashboard → **Developer** → **API keys**, or login flow for a JWT |
| Base URL | Usually `https://api.tabi.africa/api/v1` (default in the client) |
| Channel ID | **Channels** → open a channel → copy the ID from the URL or screen |

Some operations (for example creating API keys) require a **user JWT**, not a channel key. The method descriptions below mention that where it matters.

---

## How the client is organised

`TabiClient` exposes **resource groups**. Each group maps to an area of the REST API (same idea as PHP `->messages()` and Python `client.messages`).

| Group on `TabiClient` | REST areas |
|----------------------|------------|
| `auth()`, `workspaces()` | Auth, workspaces, members, invites |
| `channels()`, `messages()`, `conversations()`, `contacts()`, `quickReplies()`, `notifications()` | Lines, sends, inbox, people, shortcuts |
| `automationTemplates()`, `automationInstalls()`, `campaigns()` | Template catalog, installed flows, broadcasts |
| `apiKeys()`, `webhooks()`, `integrations()` | API keys (JWT for create), webhooks, third-party links |
| `files()`, `analytics()` | Uploads, metrics |

Method names in Dart are **camelCase**. JSON keys in maps are **exactly** as in the HTTP API (camelCase), e.g. `refreshToken`, `assignedTo`.

---

## Request bodies and the full API

Use this README for **copy-paste examples**, the **`messages().send` table** below, **webhook event names**, and the **Resources** section.

For **every** optional field, enum, query parameter, and response shape, use the **Dashboard → Developer → API reference** (OpenAPI) as the source of truth.

---

## Send message body

Maps to `POST /channels/{channelId}/send` (`messages().send` in this SDK).

| Field | Required | Description |
|-------|----------|-------------|
| `to` | yes | Recipient phone: digits only, international, no leading `+` in JSON. |
| `content` | yes | Text or caption, up to 4096 characters. |
| `messageType` | no | `text` (default), `image`, `video`, `audio`, `document`. |
| `mediaUrl` | for media | Public URL or base64 data URI when `messageType` is not `text`. |
| `messageClass` | no | e.g. `transactional` (typical for API), `conversational_reply`, `triggered_followup`, `broadcast`. |
| `contactName` | no | Display name when creating a new contact. |
| `channelId` | no | If set, must match the channel in the URL. |

Stickers, polls, location, contacts, reactions, etc. use **other** methods on `messages()` (see [Resources](#resources-all-methods)); see OpenAPI for their bodies.

---

## Webhook `events`

When creating a webhook subscription, pass a list of event names. Use `*` for all. Common values:

| Event | Meaning |
|-------|---------|
| `message.inbound` | New inbound message on a channel. |
| `message.status` | Outbound status update (delivered, read, failed, …). |
| `conversation.created` | New conversation. |

Payload shape: `{ "event": "<name>", "data": { ... }, "timestamp": "<ISO8601>" }`. Verify signatures with your subscription secret (see API reference).

---

## OTP over WhatsApp

### Hosted OTP (recommended)

The API can generate the code, store a hash, send WhatsApp, and verify—use the same credential as for `messages().send` (for example workspace API key with `messages:send`).

```dart
await client.channels().sendOtp('channel-uuid', {
  'phone': '+2347000000000',
});

await client.channels().verifyOtp('channel-uuid', {
  'phone': '+2347000000000',
  'code': '123456',
});
```

REST: `POST /channels/{channelId}/otp/send`, `POST /channels/{channelId}/otp/verify`.

**Security:** call these only from **your backend**. Never put the Tabi API key in a mobile or web client; the customer app talks to your server, and your server calls Tabi.

### Compliance

- OTP uses the same WhatsApp Business channel and rate limits as other sends.
- Follow Meta / WhatsApp policies for templates, opt-in, and WABA setup ([Meta docs](https://developers.facebook.com/docs/whatsapp)).
- Use OTP only for real verification flows (e.g. sign-in), not for cold outreach or marketing.

### Custom OTP (without hosted routes)

Generate codes, hash them, store them in your database or Redis, then send the text with `messages().send` and `messageClass` appropriate for transactional traffic. The Python SDK documents a full DIY pattern with helpers; in Dart you implement storage yourself and use the same JSON bodies as in OpenAPI.

---

## Resources (all methods)

### Auth

Login, register, tokens, session, invite preview.

```dart
await client.auth().login('user@example.com', 'password');
await client.auth().register({...});
await client.auth().refresh('refresh_token_from_api');
await client.auth().me();
await client.auth().logout();
await client.auth().invitePreview('invite_token');
```

### Channels

```dart
await client.channels().list();
await client.channels().get('channel-id');
await client.channels().create({'name': 'Support', 'provider': 'messaging'});
await client.channels().connect('channel-id');
await client.channels().connect('channel-id', {'optional': 'body'});
await client.channels().disconnect('channel-id');
await client.channels().status('channel-id');
await client.channels().update('channel-id', {'name': 'Renamed'});
await client.channels().reconnect('channel-id');
await client.channels().delete('channel-id');

await client.channels().sendOtp('channel-id', {'phone': '+2347000000000'});
await client.channels().verifyOtp('channel-id', {
  'phone': '+2347000000000',
  'code': '123456',
});
```

`update` typically needs a **user JWT** (not only a channel key)—see OpenAPI.

### Messages

```dart
await client.messages().send('channel-id', {
  'to': '2347000000000',
  'content': 'Hello',
  'messageClass': 'transactional',
});

await client.messages().send('channel-id', {
  'to': '2347000000000',
  'content': 'See image',
  'messageType': 'image',
  'mediaUrl': 'https://cdn.example.com/a.png',
});

await client.messages().get('message-id');
await client.messages().listByConversation('conversation-id', {'page': 1, 'limit': 50});
await client.messages().reply('conversation-id', {'content': 'Reply text'});

await client.messages().sendSticker('channel-id', {...});
await client.messages().sendContact('channel-id', {...});
await client.messages().sendLocation('channel-id', {
  'to': '234...',
  'latitude': 6.5,
  'longitude': 3.3,
});
await client.messages().sendPoll('channel-id', {...});
await client.messages().react('channel-id', 'message-id', {'emoji': '👍'});
await client.messages().markRead('channel-id', 'message-id');
await client.messages().revoke('channel-id', 'message-id');
await client.messages().edit('channel-id', 'message-id', {'content': 'Edited'});
await client.messages().downloadMedia('channel-id', 'message-id');
```

### Contacts

```dart
await client.contacts().list({'page': 1, 'search': 'John'});
await client.contacts().get('contact-id');
await client.contacts().create({'phone': '2347000000000', 'firstName': 'Jane'});
await client.contacts().update('contact-id', {'firstName': 'Janet'});
await client.contacts().delete('contact-id');
await client.contacts().import({'contacts': []});
await client.contacts().getTags('contact-id');
await client.contacts().addTag('contact-id', 'vip');
await client.contacts().removeTag('contact-id', 'vip');
await client.contacts().optIn('contact-id');
await client.contacts().optOut('contact-id');
```

### Conversations

```dart
await client.conversations().list({'status': 'open', 'page': 1});
await client.conversations().get('conversation-id');
await client.conversations().update('conversation-id', {'assignedTo': 'member-uuid'});
await client.conversations().resolve('conversation-id');
await client.conversations().reopen('conversation-id');
await client.conversations().markRead('conversation-id');
```

### Webhooks

```dart
await client.webhooks().create({...});
await client.webhooks().list();
await client.webhooks().get('id');
await client.webhooks().update('id', {...});
await client.webhooks().delete('id');
await client.webhooks().ping('id');
await client.webhooks().rotateSecret('id');
await client.webhooks().deliveryLogs({'page': 1});
await client.webhooks().startTestCapture({...});
await client.webhooks().stopTestCapture({...});
await client.webhooks().testCaptureStatus({...});
```

### API keys

Creating keys requires a **user JWT**, not a workspace API key.

```dart
await client.apiKeys().create({
  'name': 'Production',
  'scopes': ['messages:send', 'channels:read'],
});
await client.apiKeys().list();
await client.apiKeys().revoke('key-id');
await client.apiKeys().delete('key-id');
```

### Files

```dart
await client.files().list();
await client.files().get('file-id');
await client.files().getUrl('file-id');
await client.files().delete('file-id');
```

### Campaigns

```dart
await client.campaigns().create({...});
await client.campaigns().list({'page': 1});
await client.campaigns().get('id');
await client.campaigns().update('id', {...});
await client.campaigns().delete('id');
await client.campaigns().schedule('id');
await client.campaigns().pause('id');
await client.campaigns().resume('id');
await client.campaigns().cancel('id');
```

### Automation templates

```dart
await client.automationTemplates().list();
await client.automationTemplates().get('template-id');
```

### Automation installs

```dart
await client.automationInstalls().install({...});
await client.automationInstalls().list();
await client.automationInstalls().get('id');
await client.automationInstalls().update('id', {...});
await client.automationInstalls().enable('id');
await client.automationInstalls().disable('id');
await client.automationInstalls().uninstall('id');
```

### Quick replies

```dart
await client.quickReplies().list();
await client.quickReplies().create({'shortcut': '/hi', 'body': 'Hello!'});
await client.quickReplies().update('id', {'body': '...'});
await client.quickReplies().delete('id');
```

### Analytics

```dart
await client.analytics().dashboard({'from': '2026-01-01', 'to': '2026-01-31'});
await client.analytics().channels({...});
await client.analytics().conversations({...});
```

### Notifications

```dart
await client.notifications().list({'page': 1});
await client.notifications().markRead('id');
await client.notifications().markAllRead();
await client.notifications().unreadCount();
```

### Integrations

```dart
await client.integrations().listProviders();
await client.integrations().create({...});
await client.integrations().list();
await client.integrations().get('id');
await client.integrations().update('id', {...});
await client.integrations().delete('id');
await client.integrations().test('id');
```

### Workspaces

```dart
await client.workspaces().list();
await client.workspaces().get('workspace-id');
await client.workspaces().create({'name': 'Team'});
await client.workspaces().update('workspace-id', {'name': 'Renamed'});
await client.workspaces().listMembers('workspace-id');
await client.workspaces().inviteMember('workspace-id', {
  'email': 'member@example.com',
  'roleSlug': 'admin',
});
```

---

## Error handling

Failed calls throw `TabiException` with `message`, `statusCode`, and optional `body` (decoded JSON when the API returns JSON).

```dart
import 'package:tabi_sdk/tabi_sdk.dart';

try {
  await client.messages().send('channel-id', {'to': '234...', 'content': 'Hi'});
} on TabiException catch (e) {
  print('${e.statusCode} ${e.message}');
  print(e.body);
}
```

| Status | Typical cause |
|--------|----------------|
| `400` | Invalid payload |
| `401` | Bad or expired credential |
| `403` | Missing scope |
| `404` | Not found |
| `429` | Rate limited |
| `500` | Server error |

On `429`, back off; do not retry in a tight loop.

---

## Return values

Successful responses are **decoded JSON** (`Map`, `List`, or scalar) after the API envelope is unwrapped. Exact shapes match the OpenAPI schemas for each endpoint.

---

## Requirements

- Dart SDK **>= 3.0.0** (Flutter apps use the same `environment` constraint in `pubspec.yaml`).
- Dependency: **`dio`** (HTTP client).
- **Platforms:** Android, iOS, Linux, macOS, Web, and Windows (pure Dart + `dio`; no `dart:io` in `lib/`).

---

## API documentation (dartdoc)

After you add the dependency, browse generated docs on pub.dev:

**[pub.dev/documentation/tabi_sdk](https://pub.dev/documentation/tabi_sdk/latest/)**

That page lists `TabiClient`, resource classes, and methods. For request/response field details, use the [OpenAPI reference](https://tabi.africa/api-docs) in the Tabi dashboard.

---

## Author

**Timothy Dake**

- **LinkedIn:** [linkedin.com/in/timothy-dake-14801571](https://www.linkedin.com/in/timothy-dake-14801571/)
- **X (Twitter):** [@timothydake](https://x.com/timothydake)
- **Email:** [timdake4@gmail.com](mailto:timdake4@gmail.com)

---

## Support

- **Bugs and feature requests:** [GitHub issues](https://github.com/Tabi-messaging/tabi-sdk-dart/issues)
- **Product / API questions:** [tabi.africa](https://tabi.africa) and in-dashboard **Developer → API reference**

---

## Related SDKs

- **PHP:** [`tabi/sdk` on Packagist](https://packagist.org/packages/tabi/sdk)
- **Python:** [`tabi-sdk` on PyPI](https://pypi.org/project/tabi-sdk/)
- **JavaScript / TypeScript:** [`tabi-sdk` on npm](https://www.npmjs.com/package/tabi-sdk)
- **HTTP reference:** [tabi.africa API docs](https://tabi.africa/api-docs)

---

## License

MIT — see [LICENSE](https://github.com/Tabi-messaging/tabi-sdk-dart/blob/main/LICENSE).
