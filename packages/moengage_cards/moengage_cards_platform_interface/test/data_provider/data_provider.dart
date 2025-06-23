const String singleCard = '''
{
  "id": 210,
  "card_id": "123457",
  "category": "promotions",
  "template_data": {
    "type": "illustration",
    "kvPairs": {
    },
    "containers": [
      {
        "id": 10,
        "type": "illustration",
        "style": {
          "bgColor": "#ffffff"
        },
        "actions": [
         {
            "name": "navigate",
            "type": "deepLink",
            "value": "https://google.com",
            "kvPairs": {}
        }
        ],
        "widgets": [
          {
            "id": 0,
            "type": "image",
            "content": "https://picsum.photos/200/200",
            "style": {
              "bgColor": "#1a2a3a"
            },
            "actions": [
              {
                "name": "navigate",
                "type": "screenName",
                "value": "com.moengage.sampleapp.MainActivity",
                "kvPairs": {
                }
              }
            ],
            "accessibility": null
          },
          {
            "id": 1,
            "type": "text",
            "content": "Some Header",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": [],
            "accessibility": null
          },
          {
            "id": 2,
            "type": "text",
            "content": "Some message",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": [],
            "accessibility": null
          },
          {
            "id": 3,
            "type": "button",
            "content": "CLICK ME!",
            "style": {
              "bgColor": "#FFFFF",
              "fontSize": 2
            },
            "actions": [],
            "accessibility": null
          }
        ]
      }
    ]
  },
  "meta_data": {
    "campaignState": {
      "localShowCount": 0,
      "isClicked": false,
      "firstReceived": 14545545,
      "firstSeen": 12333566,
      "totalShowCount": 10
    },
    "deletionTime": 12333566,
    "display_controls": {
      "expire_at": 100000,
      "expire_after_seen": 1233456,
      "expire_after_delivered": 2592000,
      "max_times_to_show": 10,
      "is_pin": false,
      "show_time": {
        "start_time": "11:11",
        "end_time": "12:22"
      }
    },
    "metaData": {
    },
    "isNewCard": false,
    "updated_at": 54768,
    "created_at":123456789,
    "campaignPayload": {
    }
  }
}
''';

const String cardsInfoJson = '''
{
   "accountMeta":{
     "appId" : ""
   },
   "data":{
     "shouldShowAllTab":true,
     "categories": ["promotions"],
     "cards":[
     {
  "id": 210,
  "card_id": "123457",
  "category": "promotions",
  "template_data": {
    "type": "illustration",
    "kvPairs": {
    },
    "containers": [
      {
        "id": 10,
        "type": "illustration",
        "style": {
          "bgColor": "#ffffff"
        },
        "actions": [
         {
            "name": "navigate",
            "type": "deepLink",
            "value": "https://google.com",
            "kvPairs": {}
        }
        ],
        "widgets": [
          {
            "id": 0,
            "type": "image",
            "content": "https://picsum.photos/200/200",
            "style": {
              "bgColor": "#1a2a3a"
            },
            "actions": [
              {
                "name": "navigate",
                "type": "screenName",
                "value": "com.moengage.sampleapp.MainActivity",
                "kvPairs": {
                }
              }
            ]
          },
          {
            "id": 1,
            "type": "text",
            "content": "Some Header",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": []
          },
          {
            "id": 2,
            "type": "text",
            "content": "Some message",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": []
          },
          {
            "id": 3,
            "type": "button",
            "content": "CLICK ME!",
            "style": {
              "bgColor": "#FFFFF",
              "fontSize": 2
            },
            "actions": []
          }
        ]
      }
    ]
  },
  "meta_data": {
    "campaignState": {
      "localShowCount": 0,
      "isClicked": false,
      "firstReceived": 14545545,
      "firstSeen": 12333566,
      "totalShowCount": 10
    },
    "deletionTime": 12333566,
    "display_controls": {
      "expire_at": 100000,
      "expire_after_seen": 1233456,
      "expire_after_delivered": 2592000,
      "max_times_to_show": 10,
      "is_pin": false,
      "show_time": {
        "start_time": "11:11",
        "end_time": "12:22"
      }
    },
    "metaData": {
    },
    "isNewCard": false,
    "updated_at": 54768,
    "created_at":123456789,
    "campaignPayload": {
    }
  }
}
     ]
   }
}
''';

const String isAllCategoryEnabledJson = '''
{
   "accountMeta":{
     "appId" : ""
   },
   "data":{
     "isAllCategoryEnabled":false
}     
}
''';

const String cardsCategoriesJson = '''
{
   "accountMeta":{
     "appId" : ""
   },
   "data":{
     "categories": ["promotion","announcement"]
}     
}
''';

const String newCardsCountJson = '''
{
   "accountMeta":{
     "appId" : ""
   },
   "data":{
     "newCardsCount": 10
}     
}
''';

const String unClickedCardsCountJson = '''
{
   "accountMeta":{
     "appId" : ""
   },
   "data":{
     "unClickedCardsCount": 20
}     
}
''';

const String cardsForCategoryJson = '''
{
   "accountMeta":{
     "appId" : ""
   },
   "data":{
     "category":"promotions",
     "cards":[
     {
  "id": 210,
  "card_id": "123457",
  "category": "promotions",
  "template_data": {
    "type": "illustration",
    "kvPairs": {
    },
    "containers": [
      {
        "id": 10,
        "type": "illustration",
        "style": {
          "bgColor": "#ffffff"
        },
        "actions": [
         {
            "name": "navigate",
            "type": "deepLink",
            "value": "https://google.com",
            "kvPairs": {}
        }
        ],
        "widgets": [
          {
            "id": 0,
            "type": "image",
            "content": "https://picsum.photos/200/200",
            "style": {
              "bgColor": "#1a2a3a"
            },
            "actions": [
              {
                "name": "navigate",
                "type": "screenName",
                "value": "com.moengage.sampleapp.MainActivity",
                "kvPairs": {
                }
              }
            ]
          },
          {
            "id": 1,
            "type": "text",
            "content": "Some Header",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": []
          },
          {
            "id": 2,
            "type": "text",
            "content": "Some message",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": []
          },
          {
            "id": 3,
            "type": "button",
            "content": "CLICK ME!",
            "style": {
              "bgColor": "#FFFFF",
              "fontSize": 2
            },
            "actions": []
          }
        ]
      }
    ]
  },
  "meta_data": {
    "campaignState": {
      "localShowCount": 0,
      "isClicked": false,
      "firstReceived": 14545545,
      "firstSeen": 12333566,
      "totalShowCount": 10
    },
    "deletionTime": 12333566,
    "display_controls": {
      "expire_at": 100000,
      "expire_after_seen": 1233456,
      "expire_after_delivered": 2592000,
      "max_times_to_show": 10,
      "is_pin": false,
      "show_time": {
        "start_time": "11:11",
        "end_time": "12:22"
      }
    },
    "metaData": {
    },
    "isNewCard": false,
    "updated_at": 54768,
    "created_at":123456789,
    "campaignPayload": {
    }
  }
}
     ]
   }
}
''';

const String cardsData = '''
{
     "category":"promotions",
      "accessibility":null,
     "cards":[
     {
  "id": 210,
  "card_id": "123457",
  "category": "promotions",
  "template_data": {
    "type": "illustration",
    "kvPairs": {
    },
    "containers": [
      {
        "id": 10,
        "type": "illustration",
        "style": {
          "bgColor": "#ffffff"
        },
        "actions": [
         {
            "name": "navigate",
            "type": "deepLink",
            "value": "https://google.com",
            "kvPairs": {}
        }
        ],
        "widgets": [
          {
            "id": 0,
            "type": "image",
            "content": "https://picsum.photos/200/200",
            "style": {
              "bgColor": "#1a2a3a"
            },
            "actions": [
              {
                "name": "navigate",
                "type": "screenName",
                "value": "com.moengage.sampleapp.MainActivity",
                "kvPairs": {
                }
              }
            ],
             "accessibility":null
          },
          {
            "id": 1,
            "type": "text",
            "content": "Some Header",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": [],
            "accessibility":null
          },
          {
            "id": 2,
            "type": "text",
            "content": "Some message",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": [],
            "accessibility":null
          },
          {
            "id": 3,
            "type": "button",
            "content": "CLICK ME!",
            "style": {
              "bgColor": "#FFFFF",
              "fontSize": 2
            },
            "actions": [],
            "accessibility":null
          }
        ]
      }
    ]
  },
  "meta_data": {
    "campaignState": {
      "localShowCount": 0,
      "isClicked": false,
      "firstReceived": 14545545,
      "firstSeen": 12333566,
      "totalShowCount": 10
    },
    "deletionTime": 12333566,
    "display_controls": {
      "expire_at": 100000,
      "expire_after_seen": 1233456,
      "expire_after_delivered": 2592000,
      "max_times_to_show": 10,
      "is_pin": false,
      "show_time": {
        "start_time": "11:11",
        "end_time": "12:22"
      }
    },
    "metaData": {
    },
    "isNewCard": false,
    "updated_at": 54768,
    "created_at":123456789,
    "campaignPayload": {
    }
  }
}]
}
''';

const String cardsInfoData = '''
{
     "shouldShowAllTab":true,
     "accessibility": null,
     "categories": ["promotions"],
     "cards":[
     {
  "id": 210,
  "card_id": "123457",
  "category": "promotions",
  "template_data": {
    "type": "illustration",
    "kvPairs": {
    },
    "containers": [
      {
        "id": 10,
        "type": "illustration",
        "style": {
          "bgColor": "#ffffff"
        },
        "actions": [
         {
            "name": "navigate",
            "type": "deepLink",
            "value": "https://google.com",
            "kvPairs": {}
        }
        ],
        "widgets": [
          {
            "id": 0,
            "type": "image",
            "content": "https://picsum.photos/200/200",
            "style": {
              "bgColor": "#1a2a3a"
            },
            "actions": [
              {
                "name": "navigate",
                "type": "screenName",
                "value": "com.moengage.sampleapp.MainActivity",
                "kvPairs": {
                }
              }
            ],
           "accessibility": null
          },
          {
            "id": 1,
            "type": "text",
            "content": "Some Header",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": [],
            "accessibility": null
          },
          {
            "id": 2,
            "type": "text",
            "content": "Some message",
            "style": {
              "bgColor": "#ed2a4a",
              "fontSize": 20
            },
            "actions": [],
            "accessibility": null
          },
          {
            "id": 3,
            "type": "button",
            "content": "CLICK ME!",
            "style": {
              "bgColor": "#FFFFF",
              "fontSize": 2
            },
            "actions": [],
            "accessibility": null
          }
        ]
      }
    ]
  },
  "meta_data": {
    "campaignState": {
      "localShowCount": 0,
      "isClicked": false,
      "firstReceived": 14545545,
      "firstSeen": 12333566,
      "totalShowCount": 10
    },
    "deletionTime": 12333566,
    "display_controls": {
      "expire_at": 100000,
      "expire_after_seen": 1233456,
      "expire_after_delivered": 2592000,
      "max_times_to_show": 10,
      "is_pin": false,
      "show_time": {
        "start_time": "11:11",
        "end_time": "12:22"
      }
    },
    "metaData": {
    },
    "isNewCard": false,
    "updated_at": 54768,
    "created_at":123456789,
    "campaignPayload": {
    }
  }
}
     ]
   }
''';

const String syncCompleteData = '''
{
"hasUpdates": true,
"syncType": "PULL_TO_REFRESH"
}
''';

const String fetchCardsData = '''
{
  "accountMeta": {
    "appId": ""
  },
  "data": {
    "cards": [
      {
        "id": 210,
        "card_id": "123457",
        "category": "promotions",
        "template_data": {
          "type": "illustration",
          "kvPairs": {},
          "containers": [
            {
              "id": 10,
              "type": "illustration",
              "style": {
                "bgColor": "#ffffff"
              },
              "actions": [
                {
                  "name": "navigate",
                  "type": "deepLink",
                  "value": "https://google.com",
                  "kvPairs": {}
                }
              ],
              "widgets": [
                {
                  "id": 0,
                  "type": "image",
                  "content": "https://picsum.photos/200/200",
                  "style": {
                    "bgColor": "#1a2a3a"
                  },
                  "actions": [
                    {
                      "name": "navigate",
                      "type": "screenName",
                      "value": "com.moengage.sampleapp.MainActivity",
                      "kvPairs": {}
                    }
                  ]
                },
                {
                  "id": 1,
                  "type": "text",
                  "content": "Some Header",
                  "style": {
                    "bgColor": "#ed2a4a",
                    "fontSize": 20
                  },
                  "actions": []
                },
                {
                  "id": 2,
                  "type": "text",
                  "content": "Some message",
                  "style": {
                    "bgColor": "#ed2a4a",
                    "fontSize": 20
                  },
                  "actions": []
                },
                {
                  "id": 3,
                  "type": "button",
                  "content": "CLICK ME!",
                  "style": {
                    "bgColor": "#FFFFF",
                    "fontSize": 2
                  },
                  "actions": []
                }
              ]
            }
          ]
        },
        "meta_data": {
          "campaignState": {
            "localShowCount": 0,
            "isClicked": false,
            "firstReceived": 14545545,
            "firstSeen": 12333566,
            "totalShowCount": 10
          },
          "deletionTime": 12333566,
          "display_controls": {
            "expire_at": 100000,
            "expire_after_seen": 1233456,
            "expire_after_delivered": 2592000,
            "max_times_to_show": 10,
            "is_pin": false,
            "show_time": {
              "start_time": "11:11",
              "end_time": "12:22"
            }
          },
          "metaData": {},
          "isNewCard": false,
          "updated_at": 54768,
          "created_at": 123456789,
          "campaignPayload": {}
        }
      }
    ]
  }
}
''';
