import 'dart:convert';

const String testAppId = 'TEST_APP_ID';

final String fetchExperiencesMetaSuccessJson = json.encode({
  'accountMeta': {'appId': testAppId},
  'data': {
    'source': 'CACHE',
    'experiences': [
      {
        'experienceKey': 'welcome_banner',
        'experienceName': 'Welcome Banner',
        'status': 'active',
      },
      {
        'experienceKey': 'home_hero',
        'experienceName': 'Home Hero',
        'status': 'paused',
      },
    ],
  },
});

final String fetchExperiencesMetaErrorJson = json.encode({
  'accountMeta': {'appId': testAppId},
  'error': {
    'code': 'SDK_NOT_INITIALIZED',
    'message': 'MoEngage SDK is not initialized',
  },
});

final String fetchExperiencesSuccessJson = json.encode({
  'accountMeta': {'appId': testAppId},
  'data': {
    'experiences': [
      {
        'experienceKey': 'welcome_banner',
        'payload': {'title': 'Welcome', 'body': 'Hello World'},
        'experienceContext': {'campaignId': 'c123', 'locale': 'en'},
        'source': 'NETWORK',
      },
    ],
    'failures': [
      {
        'reason': 'USER_NOT_IN_SEGMENT',
        'experienceKeys': ['home_hero'],
        'message': 'User does not match segment criteria',
      },
    ],
  },
});

final String fetchExperiencesEmptyJson = json.encode({
  'accountMeta': {'appId': testAppId},
  'data': {
    'experiences': [],
    'failures': [],
  },
});

final String fetchExperiencesErrorJson = json.encode({
  'accountMeta': {'appId': testAppId},
  'error': {
    'code': 'NETWORK_ERROR',
    'message': 'Request timed out',
  },
});

final String fetchExperiencesFailureWithoutMessageJson = json.encode({
  'accountMeta': {'appId': testAppId},
  'data': {
    'experiences': [],
    'failures': [
      {
        'reason': 'INVALID_EXPERIENCE_KEY',
        'experienceKeys': ['bad_key'],
      },
    ],
  },
});
