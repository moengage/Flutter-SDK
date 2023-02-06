import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_geofence/moe_geofence.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/moengage_inbox.dart';
import 'notification_util.dart';
import 'utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final MoEngageFlutter _moengagePlugin =
      MoEngageFlutter("YOUR_MOENGAGE_APP_ID");
  final MoEngageGeofence _moEngageGeofence =
      MoEngageGeofence("YOUR_MOENGAGE_APP_ID");
  final MoEngageInbox _moEngageInbox = MoEngageInbox("YOUR_MOENGAGE_APP_ID");

  void _onPushClick(PushCampaignData message) {
    print(
        "Main : _onPushClick(): This is a push click callback from native to flutter. Payload " +
            message.toString());
  }

  void _onInAppClick(ClickData message) {
    print(
        "Main : _onInAppClick() : This is a inapp click callback from native to flutter. Payload " +
            message.toString());
  }

  void _onInAppShown(InAppData message) {
    print(
        "Main : _onInAppShown() : This is a callback on inapp shown from native to flutter. Payload " +
            message.toString());
  }

  void _onInAppDismiss(InAppData message) {
    print(
        "Main : _onInAppDismiss() : This is a callback on inapp dismiss from native to flutter. Payload " +
            message.toString());
  }

  void _onInAppSelfHandle(SelfHandledCampaignData message) async {
    print(
        "Main : _onInAppSelfHandle() : This is a callback on inapp self handle from native to flutter. Payload " +
            message.toString());
    final SelfHandledActions action =
        await asyncSelfHandledDialog(buildContext);
    switch (action) {
      case SelfHandledActions.Shown:
        _moengagePlugin.selfHandledShown(message);
        break;
      case SelfHandledActions.Clicked:
        _moengagePlugin.selfHandledClicked(message);
        break;
      case SelfHandledActions.Dismissed:
        _moengagePlugin.selfHandledDismissed(message);
        break;
    }
  }

  void _onPushTokenGenerated(PushTokenData pushToken) {
    print(
        "Main : _onPushTokenGenerated() : This is callback on push token generated from native to flutter: PushToken: " +
            pushToken.toString());
  }

  void _permissionCallbackHandler(PermissionResultData data) {
    print("Permission Result: " + data.toString());
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    print("initState() : start ");
    _moengagePlugin.setPushClickCallbackHandler(_onPushClick);
    _moengagePlugin.setInAppClickHandler(_onInAppClick);
    _moengagePlugin.setInAppShownCallbackHandler(_onInAppShown);
    _moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismiss);
    _moengagePlugin.setSelfHandledInAppHandler(_onInAppSelfHandle);
    _moengagePlugin.setPushTokenCallbackHandler(_onPushTokenGenerated);
    _moengagePlugin.setPermissionCallbackHandler(_permissionCallbackHandler);
    _moengagePlugin.initialise();
    print("initState() : end ");
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    //Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
  }

  late BuildContext buildContext;
  final fcm = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    print("Main : build() ");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _moengagePlugin.onOrientationChanged();
              },
              child: Text("Orientation Change"),
            ),
          ],
        ),
        body: new Center(
          child: new ListView(
            children: ListTile.divideTiles(context: context, tiles: [
              new ListTile(
                  title: new Text("Track Event with Attributes"),
                  onTap: () async {
                    var details = MoEProperties();
                    details
                        .addAttribute("temp", 567)
                        .addAttribute("temp1", true)
                        .addAttribute("temp2", 12.30)
                        .addAttribute("stringAttr", "string val")
                        .addAttribute("attrName1", "attrVal")
                        .addAttribute("attrName2", false)
                        .addAttribute("attrName3", 123563563)
                        .addAttribute("arrayAttr", [
                          "str1",
                          12.8,
                          "str2",
                          123,
                          true,
                          {"hello": "testing"}
                        ])
                        .setNonInteractiveEvent()
                        .addAttribute(
                            "location1", new MoEGeoLocation(12.1, 77.18))
                        .addAttribute(
                            "location2", new MoEGeoLocation(12.2, 77.28))
                        .addAttribute(
                            "location3", new MoEGeoLocation(12.3, 77.38))
                        .addISODateTime("dateTime1", "2019-12-02T08:26:21.170Z")
                        .addISODateTime(
                            "dateTime2", "2019-12-06T08:26:21.170Z");
                    final String value =
                        await asyncInputDialog(context, "Event name");
                    print("Main: Event name : $value");
                    _moengagePlugin.trackEvent(
                      eventName: value,
                      eventAttributes: details,
                    );
                  }),
              new ListTile(
                  title: new Text("Track Interactive Event with Attributes"),
                  onTap: () async {
                    var details = MoEProperties();
                    details
                        .addAttribute("temp", 567)
                        .addAttribute("temp1", true)
                        .addAttribute("temp2", 12.30)
                        .addAttribute("stringAttr", "string val")
                        .addAttribute("attrName1", "attrVal")
                        .addAttribute("attrName2", false)
                        .addAttribute("attrName3", 123563563)
                        .addAttribute("arrayAttr", [
                          "str1",
                          12.8,
                          "str2",
                          123,
                          true,
                          {"hello": "testing"}
                        ])
                        .addAttribute(
                            "location1", new MoEGeoLocation(12.1, 77.18))
                        .addAttribute(
                            "location2", new MoEGeoLocation(12.2, 77.28))
                        .addAttribute(
                            "location3", new MoEGeoLocation(12.3, 77.38))
                        .addISODateTime("dateTime1", "2019-12-02T08:26:21.170Z")
                        .addISODateTime(
                            "dateTime2", "2019-12-06T08:26:21.170Z");
                    final String value =
                        await asyncInputDialog(context, "Event name");
                    print("Main: Event name : $value");
                    _moengagePlugin.trackEvent(
                      eventName: value,
                      eventAttributes: details,
                    );
                  }),
              new ListTile(
                  title: Text("Track Only Event"),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, "Event name");
                    print("Main: Event name : $value");
                    _moengagePlugin.trackEvent(eventName: value);
                    _moengagePlugin.trackEvent(
                      eventName: value,
                      eventAttributes: MoEProperties(),
                    );
                  }),
              new ListTile(
                  title: new Text("Set Unique Id"),
                  onTap: () async {
//                    _moengagePlugin.setUniqueId(null);
                    final String value =
                        await asyncInputDialog(context, "Unique Id");
                    print("Main: UniqueId: $value");
                    _moengagePlugin.setUniqueId(value);
                  }),
              new ListTile(
                  title: new Text("Set UserName"),
                  onTap: () async {
                    _moengagePlugin.setUserName("tesst");
                    final String value =
                        await asyncInputDialog(context, "User Name");
                    print("Main: UserName: $value");
                    _moengagePlugin.setUserName(value);
                  }),
              new ListTile(
                  title: new Text("Set FirstName"),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, "First Name");
                    print("Main: FisrtName: $value");
                    _moengagePlugin.setFirstName(value);
                  }),
              new ListTile(
                  title: new Text("Set LastName"),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, "Last Name");
                    print("Main: Last Name: $value");
                    _moengagePlugin.setLastName(value);
                  }),
              new ListTile(
                  title: new Text("Set Email-Id"),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, "EmailId");
                    print("Main: EmailId: $value");
                    _moengagePlugin.setEmail(value);
                  }),
              new ListTile(
                  title: new Text("Set Phone Number"),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, "Phone Number");
                    print("Main: Phone Number: $value");
                    _moengagePlugin.setPhoneNumber(value);
                  }),
              new ListTile(
                  title: new Text("Set Gender"),
                  onTap: () {
                    _moengagePlugin.setGender(MoEGender.female);
                  }),
              new ListTile(
                  title: new Text("Set Location"),
                  onTap: () {
                    _moengagePlugin.setLocation(new MoEGeoLocation(23.1, 21.2));
                  }),
              new ListTile(
                  title: Text("Set Birthday"),
                  onTap: () {
                    _moengagePlugin.setBirthDate("2019-12-02T08:26:21.170Z");
                  }),
              new ListTile(
                title: Text("Set Alias"),
                onTap: () async {
                  final String value = await asyncInputDialog(context, "Alias");
                  print("Main: Alias : $value");
                  _moengagePlugin.setAlias(value);
                },
              ),
              new ListTile(
                title: Text("Set Custom User Attributes"),
                onTap: () {
                  _moengagePlugin.setUserAttribute(
                    userAttributeName: "userAttr-bool",
                    userAttributeValue: true,
                  );
                  _moengagePlugin.setUserAttribute(
                    userAttributeName: "userAttr-int",
                    userAttributeValue: 1443322,
                  );
                  _moengagePlugin.setUserAttribute(
                    userAttributeName: "userAttr-Double",
                    userAttributeValue: 45.4567,
                  );
                  _moengagePlugin.setUserAttribute(
                    userAttributeName: "userAttr-String",
                    userAttributeValue: "This is a string",
                  );
                },
              ),
              new ListTile(
                title: Text("Set UserAttribute Timestamp"),
                onTap: () {
                  _moengagePlugin.setUserAttributeIsoDate(
                    userAttributeName: "timeStamp",
                    isoDateString: "2019-12-02T08:26:21.170Z",
                  );
                },
              ),
              new ListTile(
                title: Text("Set UserAttribute Location"),
                onTap: () {
                  _moengagePlugin.setUserAttributeLocation(
                    userAttributeName: "locationAttr",
                    location: MoEGeoLocation(72.8, 53.2),
                  );
                },
              ),
              new ListTile(
                  title: Text("App Status - Install"),
                  onTap: () {
                    _moengagePlugin.setAppStatus(MoEAppStatus.install);
                  }),
              new ListTile(
                  title: Text("App Status - Update"),
                  onTap: () {
                    _moengagePlugin.setAppStatus(MoEAppStatus.update);
                  }),
              new ListTile(
                  title: Text("iOS -- Register For Push"),
                  onTap: () {
                    _moengagePlugin.registerForPushNotification();
                  }),
              new ListTile(
                  title: Text("iOS -- Start Geofence"),
                  onTap: () {
                    _moEngageGeofence.startGeofenceMonitoring();
                  }),
              new ListTile(
                  title: Text("Show InApp"),
                  onTap: () {
                    _moengagePlugin.showInApp();
                  }),
              new ListTile(
                  title: Text("Show Self Handled InApp"),
                  onTap: () {
                    buildContext = context;
                    _moengagePlugin.getSelfHandledInApp();
                  }),
              new ListTile(
                  title: Text("Set InApp Contexts"),
                  onTap: () {
                    _moengagePlugin.setCurrentContext(["HOME", "SETTINGS"]);
                  }),
              new ListTile(
                  title: Text("Reset Contexts"),
                  onTap: () {
                    _moengagePlugin.resetCurrentContext();
                  }),
              new ListTile(
                  title: Text("Android -- FCM Push Token"),
                  onTap: () {
//                     Token passed here is just for illustration purposes. Please pass the actual token instead.
//                    _moengagePlugin.passFCMPushToken(null);
                    NotificationUtil.setupFcm(fcm, _moengagePlugin);
                  }),
              new ListTile(
                  title: Text("Android -- PushKit Push Token"),
                  onTap: () async {
                    // Token passed here is just for illustration purposes. Please pass the actual token instead.
                    final fcmToken = await fcm.getToken();
                    if (fcmToken != null)
                      _moengagePlugin.passPushKitPushToken(fcmToken);
                  }),
              new ListTile(
                  title: Text("Android -- FCM Push Payload"),
                  onTap: () {
                    // this payload is only for illustration purpose. Please pass the actual push payload.
                    var pushPayload = Map<String, String>();
                    pushPayload.putIfAbsent("push_from", () => "moengage");
                    pushPayload.putIfAbsent("gcm_title", () => "Title");
                    pushPayload.putIfAbsent(
                        "moe_app_id", () => "DAO6UGZ73D9RTK8B5W96TPYN");
                    pushPayload.putIfAbsent(
                        "gcm_notificationType", () => "normal notification");
                    pushPayload.putIfAbsent("gcm_alert", () => "Message");

                    pushPayload.putIfAbsent("gcm_campaign_id",
                        () => DateTime.now().millisecondsSinceEpoch.toString());
                    pushPayload.putIfAbsent("gcm_activityName",
                        () => "com.moengage.sampleapp.MainActivity");
                    _moengagePlugin.passFCMPushPayload(pushPayload);
                  }),
              new ListTile(
                  title: Text("Enable data tracking"),
                  onTap: () {
                    _moengagePlugin.enableDataTracking();
                  }),
              new ListTile(
                  title: Text("Disable data tracking"),
                  onTap: () {
                    _moengagePlugin.disableDataTracking();
                  }),
              new ListTile(
                title: Text("Logout"),
                onTap: () {
                  _moengagePlugin.logout();
                },
              ),
              new ListTile(
                title: Text("Inbox: Un-Clicked Count"),
                onTap: () async {
                  int count = await _moEngageInbox.getUnClickedCount();
                  print("Main : Un-clicked Count " + count.toString());
                },
              ),
              new ListTile(
                title: Text("Inbox: Get all messages"),
                onTap: () async {
                  InboxData? data = await _moEngageInbox.fetchAllMessages();
                  if (data != null) {
                    print("Main : Inbox Messages count: " +
                        data.messages.length.toString());
                    if (data.messages.length > 0) {
                      for (final message in data.messages) {
                        print("Main : Inbox Messages " + message.toString());
                      }
                    }
                  }
                },
              ),
              new ListTile(
                title: Text("Inbox: Track all messages"),
                onTap: () async {
                  InboxData? data = await _moEngageInbox.fetchAllMessages();
                  if (data != null) {
                    print("Main : Inbox Messages count: " +
                        data.messages.length.toString());
                    if (data.messages.length > 0) {
                      for (final message in data.messages) {
                        print("Main : Tracking inbox message: " +
                            message.toString());
                        _moEngageInbox.trackMessageClicked(message);
                      }
                    }
                  }
                },
              ),
              new ListTile(
                title: Text("Inbox: Delete all messages"),
                onTap: () async {
                  InboxData? data = await _moEngageInbox.fetchAllMessages();
                  if (data != null) {
                    print("Main : Inbox Messages count: " +
                        data.messages.length.toString());
                    if (data.messages.length > 0) {
                      for (final message in data.messages) {
                        print("Main : Deleting inbox message: " +
                            message.toString());
                        _moEngageInbox.deleteMessage(message);
                      }
                    }
                  }
                },
              ),
              new ListTile(
                title: Text("Enable Sdk"),
                onTap: () async {
                  _moengagePlugin.enableSdk();
                },
              ),
              new ListTile(
                title: Text("Disable Sdk"),
                onTap: () async {
                  _moengagePlugin.disableSdk();
                },
              ),
              new ListTile(
                title: Text("Android- Enable Android Id"),
                onTap: () async {
                  _moengagePlugin.enableAndroidIdTracking();
                },
              ),
              new ListTile(
                title: Text("Android- Disable Android Id"),
                onTap: () async {
                  _moengagePlugin.disableAndroidIdTracking();
                },
              ),
              new ListTile(
                title: Text("Android- Enable Ad Id"),
                onTap: () async {
                  _moengagePlugin.enableAdIdTracking();
                },
              ),
              new ListTile(
                title: Text("Android- Disable Ad Id"),
                onTap: () async {
                  _moengagePlugin.disableAdIdTracking();
                },
              ),
              new ListTile(
                title: Text("Android- Navigate to Settings"),
                onTap: () async {
                  _moengagePlugin.navigateToSettingsAndroid();
                },
              ),
              new ListTile(
                title: Text("Android- Request Push Permission"),
                onTap: () async {
                  _moengagePlugin.requestPushPermissionAndroid();
                },
              ),
              new ListTile(
                title: Text("Android- Mock push permission granted"),
                onTap: () async {
                  _moengagePlugin.pushPermissionResponseAndroid(true);
                },
              ),
              new ListTile(
                title: Text("Android- Mock push permission denied"),
                onTap: () async {
                  _moengagePlugin.pushPermissionResponseAndroid(false);
                },
              )
            ]).toList(),
          ),
        ),
      ),
    );
  }
}
