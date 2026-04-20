import 'resources/api_keys.dart';
import 'resources/analytics.dart';
import 'resources/auth.dart';
import 'resources/automation_installs.dart';
import 'resources/automation_templates.dart';
import 'resources/campaigns.dart';
import 'resources/channels.dart';
import 'resources/contacts.dart';
import 'resources/conversations.dart';
import 'resources/files.dart';
import 'resources/integrations.dart';
import 'resources/messages.dart';
import 'resources/notifications.dart';
import 'resources/quick_replies.dart';
import 'resources/webhooks.dart';
import 'resources/workspaces.dart';
import 'tabi_http_client.dart';

/// Tabi API client. Same surface as the PHP SDK (`tabi/sdk`).
///
/// Pass a workspace or channel API key, or a user JWT when an endpoint requires it.
///
/// See https://tabi.africa/api-docs
class TabiClient {
  TabiClient(
    String apiKey, {
    String baseUrl = 'https://api.tabi.africa/api/v1',
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) : _http = TabiHttpClient(
          baseUrl: baseUrl,
          apiKey: apiKey,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
        );

  /// Advanced: use a custom [TabiHttpClient] (e.g. tests).
  TabiClient.withHttp(this._http);

  final TabiHttpClient _http;

  Auth auth() => Auth(_http);

  Channels channels() => Channels(_http);

  Messages messages() => Messages(_http);

  Contacts contacts() => Contacts(_http);

  Conversations conversations() => Conversations(_http);

  Webhooks webhooks() => Webhooks(_http);

  ApiKeys apiKeys() => ApiKeys(_http);

  Files files() => Files(_http);

  Campaigns campaigns() => Campaigns(_http);

  AutomationTemplates automationTemplates() =>
      AutomationTemplates(_http);

  AutomationInstalls automationInstalls() =>
      AutomationInstalls(_http);

  QuickReplies quickReplies() => QuickReplies(_http);

  Analytics analytics() => Analytics(_http);

  Notifications notifications() => Notifications(_http);

  Integrations integrations() => Integrations(_http);

  Workspaces workspaces() => Workspaces(_http);
}
