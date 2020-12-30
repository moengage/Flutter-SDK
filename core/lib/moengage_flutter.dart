import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/geo_location.dart';
import 'package:moengage_flutter/gender.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/push_campaign.dart';
import 'package:moengage_flutter/utils.dart';
import 'package:moengage_flutter/moe_ios_core.dart';
import 'package:moengage_flutter/moe_android_core.dart';
import 'package:moengage_flutter/moe_web_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

typedef void PushCallbackHandler(PushCampaign pushCampaign);
typedef void InAppCallbackHandler(InAppCampaign inAppCampaign);

class MoEngageFlutter {
  MethodChannel _channel = MethodChannel(channelName);
  MoEAndroidCore _moEAndroid;
  MoEiOSCore _moEiOS;
  MoEWebCore _moEWeb;
  bool isAndroid = false;
  bool isIOS = false;
  bool isWeb = false;

  PushCallbackHandler _onPushClick;
  InAppCallbackHandler _onInAppClick;
  InAppCallbackHandler _onInAppShown;
  InAppCallbackHandler _onInAppDismiss;
  InAppCallbackHandler _onInAppCustomAction;
  InAppCallbackHandler _onInAppSelfHandle;

  void initialise() {
    _channel.setMethodCallHandler(_handler);
    _channel.invokeMethod(methodInitialise);
    _moEAndroid = MoEAndroidCore(_channel);
    _moEiOS = MoEiOSCore(_channel);
    _moEWeb = MoEWebCore(_channel);

    
    try{
        if(kIsWeb) {
          isWeb = true;
        } else if(Platform.isAndroid) {
          isAndroid = true;
        } else if(Platform.isIOS) {
          isIOS = true;
        } 
    } catch (e) {
      print("Platform is neither Android, iOS nor Web");
    }
  }

  void setUpPushCallbacks(PushCallbackHandler onPushClick) {
    _onPushClick = onPushClick;
  }

  /// set up callback APIs for in-app events
  void setUpInAppCallbacks(
      {InAppCallbackHandler onInAppClick,
      InAppCallbackHandler onInAppShown,
      InAppCallbackHandler onInAppDismiss,
      InAppCallbackHandler onInAppCustomAction,
      InAppCallbackHandler onInAppSelfHandle}) {
    _onInAppClick = onInAppClick;
    _onInAppShown = onInAppShown;
    _onInAppDismiss = onInAppDismiss;
    _onInAppCustomAction = onInAppCustomAction;
    _onInAppSelfHandle = onInAppSelfHandle;
  }

  Future<dynamic> _handler(MethodCall call) async {
    print("Received callback in dart. Payload" + call.toString());
    try {
      if (call.method == callbackOnPushClick && _onPushClick != null) {
        PushCampaign pushCampaign = pushCampaignFromJson(call.arguments);
        if (pushCampaign != null) {
          _onPushClick(pushCampaign);
        }
      }
      if (call.method == callbackOnInAppClicked && _onInAppClick != null) {
        InAppCampaign inAppCampaign = inAppCampaignFromJson(call.arguments);
        if (inAppCampaign != null) {
          _onInAppClick(inAppCampaign);
        }
      }
      if (call.method == callbackOnInAppShown && _onInAppShown != null) {
        InAppCampaign inAppCampaign = inAppCampaignFromJson(call.arguments);
        if (inAppCampaign != null) {
          _onInAppShown(inAppCampaign);
        }
      }
      if (call.method == callbackOnInAppDismissed && _onInAppDismiss != null) {
        InAppCampaign inAppCampaign = inAppCampaignFromJson(call.arguments);
        if (inAppCampaign != null) {
          _onInAppDismiss(inAppCampaign);
        }
      }
      if (call.method == callbackOnInAppCustomAction &&
          _onInAppCustomAction != null) {
        InAppCampaign inAppCampaign = inAppCampaignFromJson(call.arguments);
        if (inAppCampaign != null) {
          _onInAppCustomAction(inAppCampaign);
        }
      }
      if (call.method == callbackOnInAppSelfHandled &&
          _onInAppSelfHandle != null) {
        InAppCampaign inAppCampaign = inAppCampaignFromJson(call.arguments);
        if (inAppCampaign != null) {
          _onInAppSelfHandle(inAppCampaign);
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  /// Enables MoEngage logs.
  void enableSDKLogs() {
    if (isAndroid) {
      _moEAndroid.enableSDKLogs();
    } else if (isIOS) {
      _moEiOS.enableSDKLogs();
    }
  }

  /// Tracks an event with the given attributes.
  void trackEvent(String eventName, MoEProperties eventAttributes) {
    if (isAndroid) {
      _moEAndroid.trackEvent(eventName, eventAttributes);
    } else if (isIOS) {
      _moEiOS.trackEvent(eventName, eventAttributes);
    } else if(isWeb) {
      _moEWeb.trackEvent(eventName, eventAttributes);
    }
  }

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) {
    if (isAndroid) {
      _moEAndroid.setUniqueId(uniqueId);
    } else if (isIOS) {
      _moEiOS.setUniqueId(uniqueId);
    } else if(isWeb) {
      _moEWeb.setUniqueId(uniqueId);
    }
  }

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) {
    if (isAndroid) {
      _moEAndroid.setAlias(newUniqueId);
    } else if (isIOS) {
      _moEiOS.setAlias(newUniqueId);
    } else if(isWeb) {
      _moEWeb.setAlias(newUniqueId);
    }
  }

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) {
    if (isAndroid) {
      _moEAndroid.setUserName(userName);
    } else if (isIOS) {
      _moEiOS.setUserName(userName);
    } else if(isWeb) {
      _moEWeb.setUserName(userName);
    }
  }

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) {
    if (isAndroid) {
      _moEAndroid.setFirstName(firstName);
    } else if (isIOS) {
      _moEiOS.setFirstName(firstName);
    } else if(isWeb) {
      _moEWeb.setFirstName(firstName);
    }
  }

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) {
    if (isAndroid) {
      _moEAndroid.setLastName(lastName);
    } else if (isIOS) {
      _moEiOS.setLastName(lastName);
    } else if(isWeb) {
      _moEWeb.setLastName(lastName);
    }
  }

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) {
    if (isAndroid) {
      _moEAndroid.setEmail(emailId);
    } else if (isIOS) {
      _moEiOS.setEmail(emailId);
    } else if(isWeb) {
      _moEWeb.setEmail(emailId);
    }
  }

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) {
    if (isAndroid) {
      _moEAndroid.setPhoneNumber(phoneNumber);
    } else if (isIOS) {
      _moEiOS.setPhoneNumber(phoneNumber);
    } else if(isWeb) {
      _moEWeb.setPhoneNumber(phoneNumber);
    }
  }

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) {
    if (isAndroid) {
      _moEAndroid.setGender(gender);
    } else if (isIOS) {
      _moEiOS.setGender(gender);
    } else if(isWeb) {
      _moEWeb.setGender(gender);
    }
  }

  /// Set's user's location
  void setLocation(MoEGeoLocation location) {
    if (isAndroid) {
      _moEAndroid.setLocation(location);
    } else if (isIOS) {
      _moEiOS.setLocation(location);
    }
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) {
    if (isAndroid) {
      _moEAndroid.setBirthDate(birthDate);
    } else if (isIOS) {
      _moEiOS.setBirthDate(birthDate);
    } else if(isWeb) {
      _moEWeb.setBirthDate(birthDate);
    }
  }

  /// Tracks a user attribute.
  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    if (userAttributeName.isEmpty) {
      print("User Attribute Name cannot be empty");
      return;
    }
    if (userAttributeValue is String ||
        userAttributeValue is int ||
        userAttributeValue is double ||
        userAttributeValue is bool) {
      if (isAndroid) {
        _moEAndroid.setUserAttribute(userAttributeName, userAttributeValue);
      } else if (isIOS) {
        _moEiOS.setUserAttribute(userAttributeName, userAttributeValue);
      } else if(isWeb) {
      _moEWeb.setUserAttribute(userAttributeName, userAttributeValue);
      }
    } else {
      print(
          "Only String, Numbers and Bool values supported as User Attributes");
    }
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setUserAttributeIsoDate(String userAttributeName, String isoDateString) {
    if (isAndroid) {
      _moEAndroid.setUserAttributeIsoDate(userAttributeName, isoDateString);
    } else if (isIOS) {
      _moEiOS.setUserAttributeIsoDate(userAttributeName, isoDateString);
    } else if(isWeb) {
      _moEWeb.setUserAttributeIsoDate(userAttributeName, isoDateString);
    }
  }

  /// Tracks the given location as user attribute.
  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location) {
    if (isAndroid) {
      _moEAndroid.setUserAttributeLocation(userAttributeName, location);
    } else if (isIOS) {
      _moEiOS.setUserAttributeLocation(userAttributeName, location);
    }
  }

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus) {
    if (isAndroid) {
      _moEAndroid.setAppStatus(appStatus);
    } else if (isIOS) {
      _moEiOS.setAppStatus(appStatus);
    }
  }

  /// Try to show an InApp Message.
  void showInApp() {
    if (isAndroid) {
      _moEAndroid.showInApp();
    } else if (isIOS) {
      _moEiOS.showInApp();
    }
  }

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  void logout() {
    if (isAndroid) {
      _moEAndroid.logout();
    } else if (isIOS) {
      _moEiOS.logout();
    } else if(isWeb) {
      _moEWeb.logout();
    }
  }

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  void getSelfHandledInApp() {
    if (isAndroid) {
      _moEAndroid.getSelfHandledInApp();
    } else if (isIOS) {
      _moEiOS.getSelfHandledInApp();
    }
  }

  /// Mark self-handled campaign as shown.
  /// API to be called only when in-app is self handled
  void selfHandledShown(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = selfHandledActionShown;
    if (isAndroid) {
      _moEAndroid.selfHandledCallback(payload);
    } else if (isIOS) {
      _moEiOS.selfHandledCallback(payload);
    }
  }

  /// Mark self-handled campaign as primary clicked.
  /// API to be called only when in-app is self handled
  void selfHandledPrimaryClicked(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = selfHandledActionPrimaryClicked;
    if (isAndroid) {
      _moEAndroid.selfHandledCallback(payload);
    } else if (isIOS) {
      _moEiOS.selfHandledCallback(payload);
    }
  }

  /// Mark self-handled campaign as clicked.
  /// API to be called only when in-app is self handled
  void selfHandledClicked(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = selfHandledActionClick;
    if (isAndroid) {
      _moEAndroid.selfHandledCallback(payload);
    } else if (isIOS) {
      _moEiOS.selfHandledCallback(payload);
    }
  }

  /// Mark self-handled campaign as dismissed.
  /// API to be called only when in-app is self handled
  void selfHandledDismissed(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = selfHandledActionDismissed;
    if (isAndroid) {
      _moEAndroid.selfHandledCallback(payload);
    } else if (isIOS) {
      _moEiOS.selfHandledCallback(payload);
    }
  }

  ///Set the current context for the given user.
  void setCurrentContext(List<String> contexts) {
    if (isAndroid) {
      _moEAndroid.setCurrentContext(contexts);
    } else if (isIOS) {
      _moEiOS.setCurrentContext(contexts);
    }
  }

  void resetCurrentContext() {
    if (isAndroid) {
      _moEAndroid.resetCurrentContext();
    } else if (isIOS) {
      _moEiOS.resetCurrentContext();
    }
  }

  ///Optionally opt-out of data tracking. When data tracking is opted no event
  ///or user attribute is tracked on MoEngage Platform.
  void optOutDataTracking(bool shouldOptOutDataTracking) {
    if (isAndroid) {
      _moEAndroid.optOutDataTracking(shouldOptOutDataTracking);
    } else if (isIOS) {
      _moEiOS.optOutDataTracking(shouldOptOutDataTracking);
    }
  }

  ///Optionally opt-out of push campaigns.
  ///No push campaigns will be shown once this is opted out.
  void optOutPushTracking(bool shouldOptOutPushTracking) {
    if (isAndroid) {
      _moEAndroid.optOutPushTracking(shouldOptOutPushTracking);
    } else if (isIOS) {
      _moEiOS.optOutPushTracking(shouldOptOutPushTracking);
    }
  }

  ///Optionally opt-out of in-app campaigns.
  ///No in-app campaigns will be shown once this is  opted out.
  void optOutInAppTracking(bool shouldOptOutinAppTracking) {
    if (isAndroid) {
      _moEAndroid.optOutInAppTracking(shouldOptOutinAppTracking);
    } else if (isIOS) {
      _moEiOS.optOutInAppTracking(shouldOptOutinAppTracking);
    }
  }

  /// Push Notification Registration
  /// Note: This API is only for iOS Platform.
  void registerForPushNotification() {
    if (isIOS) {
      _moEiOS.registerForPushNotification();
    }
  }

  /// Start Geofence Monitoring, Will work only if MOGeofence CocoaPod is integrated
  /// Note: This API is only for iOS Platform.
  void startGeofenceMonitoring() {
    if (isIOS) {
      _moEiOS.startGeofenceMonitoring();
    }
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushToken(String pushToken) {
    if (isAndroid) {
      _moEAndroid.passPushToken(pushToken, pushServiceFCM);
    }
  }

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushPayload(Map<String, dynamic> payload) {
    if (isAndroid) {
      _moEAndroid.passPushPayload(payload, pushServiceFCM);
    }
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushKitPushToken(String pushToken) {
    if (isAndroid) {
      _moEAndroid.passPushToken(pushToken, pushServicePushKit);
    }
  }
}
