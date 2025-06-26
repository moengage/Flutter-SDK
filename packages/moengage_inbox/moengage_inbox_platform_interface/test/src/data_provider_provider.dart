import 'package:moengage_inbox_platform_interface/moengage_inbox_platform_interface.dart';

final InboxData inboxData = InboxData('android', [
  InboxMessage(
      1,
      '000000000000000088470679_L_0',
      TextContent('Title', 'Message', 'Summary', ''),
      false,
      Media(MediaType.image, 'https://picsum.photos/200/222'),
      [
        NavigationAction(ActionType.navigation, NavigationType.deepLink,
            'monengage://moe_app/add_to_cart?key=value', {
          'gcm_image_url': 'https://picsum.photos/200/222',
          'gcm_alert': 'Message',
          'gcm_notificationType': 'gcm_webNotification',
          'push_from': 'moengage',
          'gcm_webUrl': 'monengage://moe_app/add_to_cart',
          'moe_app_id': '12345',
          'gcm_campaign_id': '000000000000000088470679_L_0',
          'moe_channel_id': 'moe_sound_channel',
          'moe_webUrl': 'monengage://moe_app/add_to_cart?key=value',
          'gcm_subtext': 'Summary',
          'moe_cid_attr':
              "{'moe_campaign_channel': 'Push', 'moe_delivery_type': 'One Time', 'moe_campaign_id': '000000000000000088470679'}",
          'mi_image_url': 'https://picsum.photos/200/222',
          'MOE_MSG_RECEIVED_TIME': 1692080250167,
          'key': 'value',
          'gcm_title': 'Title',
          'moe_notification_posted_time': 1692080250175
        })
      ],
      'general',
      '2023-08-15T06:17:30.167Z',
      '2023-11-13T06:17:30.000Z',
      {
        'moe_app_id': '',
        'moe_notification_posted_time': 1692080250175,
        'gcm_subtext': 'Summary',
        'moe_webUrl': 'monengage://moe_app/add_to_cart?key=value',
        'gcm_notificationType': 'gcm_webNotification',
        'gcm_image_url': 'https://picsum.photos/200/222',
        'moe_cid_attr':
            "{'moe_campaign_channel': 'Push', 'moe_delivery_type': 'One Time', 'moe_campaign_id': '000000000000000088470679'}",
        'mi_image_url': 'https://picsum.photos/200/222',
        'push_from': 'moengage',
        'MOE_MSG_RECEIVED_TIME': 1692080250167,
        'key': 'value',
        'gcm_alert': 'Message',
        'gcm_title': 'Title',
        'gcm_webUrl': 'monengage://moe_app/add_to_cart',
        'gcm_campaign_id': '000000000000000088470679_L_0',
        'moe_channel_id': 'moe_sound_channel'
      },      
      "group",
      "id",
      "2023-08-15T06:17:30.167Z"
  )
]);
