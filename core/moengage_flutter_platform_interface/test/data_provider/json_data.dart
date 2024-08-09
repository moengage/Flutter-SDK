const String initPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "initConfig": {
    "pushConfig": {
      "shouldDeliverCallbackOnForegroundClick": true
    },
    "analyticsConfig": {
      "shouldTrackUserAttributeBooleanAsNumber": false
    }
  }
} 
''';

const String eventTrackingPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
    "eventName": "add_to_cart",
    "isNonInteractive": true,
    "eventAttributes": {
      "generalAttributes": {
        "string": "Mark",
        "num": 300,
        "double": 60.5,
        "bool": false,
        "json_obj": {
          "position": 1,
          "score": 96.4,
          "nested_obj": {
            "key": "value"
          },
          "array": [
            9,
            20,
            "something"
          ]
        },
        "json_array": [1,2,3]
      },
      "locationAttributes": {
        "location": {
          "latitude": 12.1,
          "longitude": 77.18
        }
      },
      "dateTimeAttributes": {
        "dateTime": "2019-12-02T08:26:21.170Z"
      }
    }
  }
}
''';

const String userNamePayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"USER_ATTRIBUTE_USER_NAME",
   "type":"general",
   "attributeValue":"user1234"
  }
} 
''';

const String uniqueIdPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"USER_ATTRIBUTE_UNIQUE_ID",
   "type":"general",
   "attributeValue":"1234"
  }
} 
''';

const String firstNamePayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"USER_ATTRIBUTE_USER_FIRST_NAME",
   "type":"general",
   "attributeValue":"Mark"
  }
} 
''';

const String lastNamePayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"USER_ATTRIBUTE_USER_LAST_NAME",
   "type":"general",
   "attributeValue":"Wood"
  }
} 
''';

const String emailIdPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"USER_ATTRIBUTE_USER_EMAIL",
   "type":"general",
   "attributeValue":"abc@gmail.com"
  }
} 
''';

const String mobileNumberPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"USER_ATTRIBUTE_USER_MOBILE",
   "type":"general",
   "attributeValue":"9876543210"
  }
} 
''';

const String genderPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"USER_ATTRIBUTE_USER_GENDER",
   "type":"general",
   "attributeValue":"female"
  }
} 
''';

const String birthDayPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"USER_ATTRIBUTE_USER_BDAY",
   "type":"general",
   "attributeValue":"2019-12-02T08:26:21.170Z"
  }
} 
''';

const String locationPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"USER_ATTRIBUTE_USER_LOCATION",
   "type":"location",
   "locationAttribute":{
         "latitude":12.1,
         "longitude":77.18
   }
  }
} 
''';

const String userAttrPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"language",
   "type":"general",
   "attributeValue":"English"
  }
} 
''';

const String userAttrStringArrayPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"string-array",
   "type":"general",
   "attributeValue":["array","of","strings"]
  }
} 
''';

const String userAttrNumberArrayPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"number-array",
   "type":"general",
   "attributeValue":[1.5,1,2.56]
  }
} 
''';

const String timeStampPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"timeStamp",
   "type":"timestamp",
   "attributeValue":"2019-12-02T08:26:21.170Z"
  }
} 
''';

const String aliasPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "alias":"1234"
     }
} 
''';

const String appStatusPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "appStatus":"INSTALL"
     }
} 
''';

const String inAppContextPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "contexts":["home","dashboard"]
     }
} 
''';

const String optOutTrackingPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "type":"data",
   "state":false
   }
} 
''';

const String updateSdkStatePayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "isSdkEnabled":false
   }
} 
''';

const String permissionStatePayload = '''
{
   "type":"push",
   "isGranted":false
} 
''';

const String pushServicePayload = '''
{
   "platform":"android",
   "token":"1234abcd",
   "pushService":"fcm"
} 
''';

const String pushCampaignPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
    "platform": "android",
    "isDefaultAction": true,
    "selfHandledPushRedirection": true,
    "payload": {
      "gcm_image_url": "https://picsum.photos/200/222",
      "gcm_alert": "Message",
      "gcm_notificationType": "gcm_webNotification",
      "push_from": "moengage",
      "gcm_webUrl": "monengage://moe_app/add_to_cart",
      "moe_app_id": "DAO6UGZ73D9RTK8B5W96TPYN_DEBUG",
      "gcm_campaign_id": "000000000000000015056066_L_0",
      "moe_channel_id": "moe_sound_channel",
      "moe_webUrl": "monengage://moe_app/add_to_cart?key=value",
      "gcm_subtext": "Summary",
      "moe_cid_attr": "{'moe_campaign_channel': 'Push','moe_delivery_type': 'One Time','moe_campaign_id': '000000000000000015056066'}",
      "mi_image_url": "https://picsum.photos/200/222",
      "MOE_NOTIFICATION_ID": 17987,
      "MOE_MSG_RECEIVED_TIME": 1692068674349,
      "key": "value",
      "gcm_title": "Title"
    }
  }
}
''';

/// r''' denotes raw string
const String selfHandledPayload = r'''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
    "campaignName": "Self handled Test in-app<::>0<::>1",
    "campaignId": "64ca642685373efd30dced83",
    "campaignContext": {
      "cid": "64ca642685373efd30dced83_F_T_IA_AB_1_P_0_L_0",
      "campaign_name": "Self handled Test in-app",
      "moe_locale_name": "Default",
      "moe_locale_id": "0",
      "moe_variation_id": "1"
    },
    "platform": "android",
    "selfHandled": {
      "payload": "{\"key1\":\"value1\",\"key2\":\"value2\",\"key3\":\"value3\"}",
      "dismissInterval": 60
    }
  }
}
''';

const String inAppPayload = '''
{
	"accountMeta": {
		"appId": ""
	},
	"data": {
		"campaignName": "test campaign<::>0<::>1",
		"campaignId": "64dafbb0fb7525971946fb39",
		"campaignContext": {
			"cid": "64dafbb0fb7525971946fb39_F_T_IA_AB_1_P_0_L_0",
			"campaign_name": "test campaign",
			"moe_locale_name": "Default",
			"moe_locale_id": "0",
			"moe_variation_id": "1"
		},
		"platform": "android"
	}
}
''';

const String inAppClickDataPayload = '''
{
	"accountMeta": {
		"appId": ""
	},
	"data": {
		"campaignName": "test campaign<::>0<::>1",
		"actionType": "navigation",
		"navigation":{
		"navigationType":"deep_linking",
		"value":"https://google.com",
		"kvPair":{}
		},
		"campaignId": "64dafbb0fb7525971946fb39",
		"campaignContext": {
			"cid": "64dafbb0fb7525971946fb39_F_T_IA_AB_1_P_0_L_0",
			"campaign_name": "test campaign",
			"moe_locale_name": "Default",
			"moe_locale_id": "0",
			"moe_variation_id": "1"
		},
		"platform": "android"
	}
}
''';

const String inAppClickData =
    r'''{"accountMeta":{"appId":""},"data":{"type":"click","campaignName":"Self handled Test in-app<::>0<::>1","campaignId":"64ca642685373efd30dced83","campaignContext":{"cid":"64ca642685373efd30dced83_F_T_IA_AB_1_P_0_L_0","campaign_name":"Self handled Test in-app","moe_locale_name":"Default","moe_locale_id":"0","moe_variation_id":"1"},"selfHandled":{"payload":"{\"key1\":\"value1\",\"key2\":\"value2\",\"key3\":\"value3\"}","dismissInterval":60},"platform":null}}''';

const String nudgePayload = r'''
{
  "accountMeta": {
    "appId": "1234"
  },
  "data": {
    "position": "bottom"
  }
}''';

const String userAttrJsonObjectPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"json-object",
   "type":"general",
   "attributeValue":{
   "key":"value"
   }
  }
} 
''';

const String userAttrArrayOfJsonObjectPayload = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
   "attributeName":"array-of-json-objects",
   "type":"general",
   "attributeValue":[{"key": "1"},{"key": "2"}]
  }
} 
''';
