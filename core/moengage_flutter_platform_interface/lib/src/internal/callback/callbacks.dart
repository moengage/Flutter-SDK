import '../../model/inapp/click_data.dart';
import '../../model/inapp/inapp_data.dart';
import '../../model/inapp/self_handled_data.dart';
import '../../model/permission_result.dart';
import '../../model/push/push_campaign_data.dart';
import '../../model/push/push_token_data.dart';

/// Push Click Callback
typedef PushClickCallbackHandler = void Function(PushCampaignData data);

/// PushToken Callback
typedef PushTokenCallbackHandler = void Function(PushTokenData data);

/// Self Handled InApp Available Callback
typedef SelfHandledInAppCallbackHandler = void Function(
    SelfHandledCampaignData data);

/// InApp Click Action Callback
typedef InAppClickCallbackHandler = void Function(ClickData data);

/// InApp Shown Callback
typedef InAppShownCallbackHandler = void Function(InAppData data);

/// InApp Dismiss Callback
typedef InAppDismissedCallbackHandler = void Function(InAppData data);

/// Push Permission Result Callback
typedef PermissionResultCallbackHandler = void Function(
    PermissionResultData data);
