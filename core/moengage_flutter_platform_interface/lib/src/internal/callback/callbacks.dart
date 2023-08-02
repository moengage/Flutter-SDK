import '../../model/inapp/click_data.dart';
import '../../model/inapp/inapp_data.dart';
import '../../model/inapp/self_handled_data.dart';
import '../../model/permission_result.dart';
import '../../model/push/push_campaign_data.dart';
import '../../model/push/push_token_data.dart';

typedef PushClickCallbackHandler = void Function(PushCampaignData data);
typedef PushTokenCallbackHandler = void Function(PushTokenData data);

typedef SelfHandledInAppCallbackHandler = void Function(
    SelfHandledCampaignData data);
typedef InAppClickCallbackHandler = void Function(ClickData data);
typedef InAppShownCallbackHandler = void Function(InAppData data);
typedef InAppDismissedCallbackHandler = void Function(InAppData data);
typedef PermissionResultCallbackHandler = void Function(
    PermissionResultData data);
