import 'model/inapp/click_data.dart';
import 'model/inapp/inapp_data.dart';
import 'model/inapp/self_handled_data.dart';
import 'model/permission_result.dart';
import 'model/push/push_campaign_data.dart';
import 'model/push/push_token_data.dart';

typedef void PushClickCallbackHandler(PushCampaignData data);
typedef void PushTokenCallbackHandler(PushTokenData data);

typedef void SelfHandledInAppCallbackHandler(SelfHandledCampaignData data);
typedef void InAppClickCallbackHandler(ClickData data);
typedef void InAppShownCallbackHandler(InAppData data);
typedef void InAppDismissedCallbackHandler(InAppData data);
typedef void PermissionResultCallbackHandler(PermissionResultData data);
