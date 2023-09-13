import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';
import 'package:moengage_flutter_platform_interface/src/model/platforms.dart';

final MoEProperties properties = MoEProperties()
    .addAttribute('string', 'Mark')
    .addAttribute('num', 300)
    .addAttribute('double', 60.5)
    .addAttribute('bool', false)
    .addAttribute('location', MoEGeoLocation(12.1, 77.18))
    .addISODateTime('dateTime', '2019-12-02T08:26:21.170Z')
    .setNonInteractiveEvent();

final MoEInitConfig moEInitConfig = MoEInitConfig(
    pushConfig: PushConfig(shouldDeliverCallbackOnForegroundClick: true));

final PushTokenData tokenData =
    PushTokenData(Platforms.android, '1234abcd', MoEPushService.fcm);

final PushCampaignData pushCampaignData = PushCampaignData(
    Platforms.android,
    AccountMeta(''),
    PushCampaign(
      true,
      <String, dynamic>{},
      {
        'gcm_image_url': 'https://picsum.photos/200/222',
        'gcm_alert': 'Message',
        'gcm_notificationType': 'gcm_webNotification',
        'push_from': 'moengage',
        'gcm_webUrl': 'monengage://moe_app/add_to_cart',
        'moe_app_id': 'DAO6UGZ73D9RTK8B5W96TPYN_DEBUG',
        'gcm_campaign_id': '000000000000000015056066_L_0',
        'moe_channel_id': 'moe_sound_channel',
        'moe_webUrl': 'monengage://moe_app/add_to_cart?key=value',
        'gcm_subtext': 'Summary',
        'moe_cid_attr':
            "{'moe_campaign_channel': 'Push','moe_delivery_type': 'One Time','moe_campaign_id': '000000000000000015056066'}",
        'mi_image_url': 'https://picsum.photos/200/222',
        'MOE_NOTIFICATION_ID': 17987,
        'MOE_MSG_RECEIVED_TIME': 1692068674349,
        'key': 'value',
        'gcm_title': 'Title'
      },
      true,
    ));

final SelfHandledCampaignData selfHandledCampaign = SelfHandledCampaignData(
    CampaignData(
        '64ca642685373efd30dced83',
        'Self handled Test in-app<::>0<::>1',
        CampaignContext('64ca642685373efd30dced83_F_T_IA_AB_1_P_0_L_0', {
          'cid': '64ca642685373efd30dced83_F_T_IA_AB_1_P_0_L_0',
          'campaign_name': 'Self handled Test in-app',
          'moe_locale_name': 'Default',
          'moe_locale_id': '0',
          'moe_variation_id': '1'
        })),
    AccountMeta(''),
    SelfHandledCampaign(
        '{"key1":"value1","key2":"value2","key3":"value3"}', 60),
    Platforms.android);

final InAppData inAppData = InAppData(
  Platforms.android,
  AccountMeta(''),
  CampaignData(
    '64dafbb0fb7525971946fb39',
    'test campaign<::>0<::>1',
    CampaignContext('64dafbb0fb7525971946fb39_F_T_IA_AB_1_P_0_L_0', {
      'cid': '64dafbb0fb7525971946fb39_F_T_IA_AB_1_P_0_L_0',
      'campaign_name': 'test campaign',
      'moe_locale_name': 'Default',
      'moe_locale_id': '0',
      'moe_variation_id': '1'
    }),
  ),
);

final ClickData clickData = ClickData(
    Platforms.android,
    AccountMeta(''),
    CampaignData(
      '64dafbb0fb7525971946fb39',
      'test campaign<::>0<::>1',
      CampaignContext('64dafbb0fb7525971946fb39_F_T_IA_AB_1_P_0_L_0', {
        'cid': '64dafbb0fb7525971946fb39_F_T_IA_AB_1_P_0_L_0',
        'campaign_name': 'test campaign',
        'moe_locale_name': 'Default',
        'moe_locale_id': '0',
        'moe_variation_id': '1'
      }),
    ),
    NavigationAction(ActionType.navigation, NavigationType.deeplink,
        'https://google.com', {}));
