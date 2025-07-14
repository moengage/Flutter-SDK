import 'dart:convert';

import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

final MoEProperties properties = MoEProperties()
    .addAttribute('string', 'Mark')
    .addAttribute('num', 300)
    .addAttribute('double', 60.5)
    .addAttribute('bool', false)
    .addAttribute('location', MoEGeoLocation(12.1, 77.18))
    .addISODateTime('dateTime', '2019-12-02T08:26:21.170Z')
    .addAttribute('json_obj', jsonObjectAttribute)
    .addAttribute('json_array', [1, 2, 3]).setNonInteractiveEvent();

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
        'moe_app_id': '',
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
    SelfHandledCampaign('{"key1":"value1","key2":"value2","key3":"value3"}', 60,
        Rules(screenName: 'Dashboard', context: [], screenNames: ['Dashboard'])),
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

final jsonObjectAttribute = {
  'position': 1,
  'score': 96.4,
  'nested_obj': {'key': 'value'},
  'array': [9, 20.0, 'something']
};

final MoEProperties dataWithInvalidProperties = MoEProperties()
    .addAttribute('null_attribute', null)
    .addAttribute('', 'Mark') // Empty Key
    .addAttribute('custom_object', const HtmlEscapeMode()) // Custom Object
    .addAttribute('list', [
      'a',
      const HtmlEscapeMode(),
      {'key': 'value'}
    ]) //List with Custom Object
    .addAttribute('map', {
      'custom_obj': const HtmlEscapeMode(),
      'valid_data': 'string'
    }) //Custom Object Inside List
    .addAttribute('my_location', MoEGeoLocation(1.2, 2.3)) //Location Attribute
    .addISODateTime('date', '2011-11-02T02:50:12.208Z') // Date Attribute
    .setNonInteractiveEvent();

final arrayWithValidData = [
  1,
  2.5,
  'string',
  true,
  {'key', 'value'},
  ['nested', 'array']
];

// Null value should be filtered out
final arrayWithNullValues = [
  1,
  2.5,
  null,
  'string',
  true,
  null,
  {'key', 'value'},
  ['nested', 'array']
];

final arrayWithInvalidAndValidData = [
  1,
  2.5,
  'string',
  const HtmlEscapeMode(), //Custom Object - Invalid
  {1: 'value'}, // Map<Int,String> - Invalid
  true,
  {'key', 'value'},
  ['nested', 'array'],
];

final arrayWithOnlyInvalidData = [
  const HtmlEscapeMode(), //Custom Object - Invalid
  {1: 'value'}, // Map<Int,String> - Invalid
];

final mapWithValidData = {
  'name': 'AAA',
  'age': 20,
  'gpa': 9.5,
  'bool': true,
  'array': [1, 2, 3],
  'nested_map': {'key': 'value'}
};

final mapWithInvalidData = {
  'custom_object': const HtmlEscapeMode(), //Invalid
  'key': null, // Null value
  'invalid_map': {1: 'value'}, // Invalid
};

final mapWithInvalidAndValidData = {
  'name': 'AAA',
  'age': 20,
  'gpa': 9.5,
  'bool': true,
  'custom_object': const HtmlEscapeMode(), //Invalid
  'invalid_map': {1: 'value'}, // Invalid
  'array': [1, 2, 3],
  'nested_map': {'key': 'value'},
  'key': null // Null value
};

final SelfHandledCampaignsData selfHandledCampaigns =
    SelfHandledCampaignsData(accountMeta: AccountMeta(''), campaigns: [
  SelfHandledCampaignData(
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
      SelfHandledCampaign('{"key1":"value1","key2":"value2","key3":"value3"}',
          60, Rules(screenName: 'Dashboard', context: [], screenNames: ['Dashboard'])),
      Platforms.android),
  SelfHandledCampaignData(
      CampaignData(
          '64ca642685373efd30dced84',
          'Self handled Test in-app<::>0<::>1',
          CampaignContext('64ca642685373efd30dced84_F_T_IA_AB_1_P_0_L_0', {
            'cid': '64ca642685373efd30dced84_F_T_IA_AB_1_P_0_L_0',
            'campaign_name': 'Self handled Test in-app1',
            'moe_locale_name': 'Default',
            'moe_locale_id': '0',
            'moe_variation_id': '1'
          })),
      AccountMeta(''),
      SelfHandledCampaign(
          '{"key1":"value1","key2":"value2","key3":"value3"}',
          60,
          Rules(screenName: 'Dashboard', context: ['section_1', 'section_2'], screenNames: ['Dashboard'])),
      Platforms.android),
]);

const dummyAppId = 'Dummy_App_ID';
const accountMetaPayload = {
  keyAccountMeta: {keyAppId: dummyAppId}
};
