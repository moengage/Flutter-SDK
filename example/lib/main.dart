import 'package:flutter/material.dart';
import 'package:moengage_flutter/model/app_status.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:moengage_flutter/model/geo_location.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/model/inapp/self_handled_data.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'dart:async';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter/properties.dart';
// import 'package:moengage_inbox/inbox_data.dart';
// import 'package:moengage_inbox/inbox_message.dart';
// import 'package:moengage_inbox/moengage_inbox.dart';
import 'utils.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final MoEngageFlutter _moengagePlugin = MoEngageFlutter("DAO6UGZ73D9RTK8B5W96TPYN");
  // final MoEngageInbox _moEngageInbox = MoEngageInbox();

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

  // void _onInAppCustomAction(InAppCampaign message) {
  //   print(
  //       "Main : _onInAppCustomAction() : This is a callback on inapp custom action from native to flutter. Payload " +
  //           message.toString());
  // }

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

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _moengagePlugin.setPushClickCallbackHandler(_onPushClick);
    _moengagePlugin.setInAppClickHandler(_onInAppClick);
    _moengagePlugin.setInAppShownCallbackHandler(_onInAppShown);
    _moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismiss);
    _moengagePlugin.setSelfHandledInAppHandler(_onInAppSelfHandle);
    // _moengagePlugin.setUpInAppCallbacks(
    //     onInAppClick: _onInAppClick,
    //     onInAppShown: _onInAppShown,
    //     onInAppDismiss: _onInAppDismiss,
    //     // onInAppCustomAction: _onInAppCustomAction,
    //     onInAppSelfHandle: _onInAppSelfHandle);
    _moengagePlugin.setPushTokenCallbackHandler(_onPushTokenGenerated);
    _moengagePlugin.initialise();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    //Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
  }

  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    print("Main : build() ");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                _moengagePlugin.onOrientationChanged();
              },
              child: Text("Orientation Change"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
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
                    _moengagePlugin.trackEvent(value, details);
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
                    _moengagePlugin.trackEvent(value, details);
                  }),
              new ListTile(
                  title: Text("Track Only Event"),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, "Event name");
                    print("Main: Event name : $value");
                    _moengagePlugin.trackEvent(value);
                    _moengagePlugin.trackEvent(value, MoEProperties());
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
                  _moengagePlugin.setUserAttribute("userAttr-bool", true);
                  _moengagePlugin.setUserAttribute("userAttr-int", 1443322);
                  _moengagePlugin.setUserAttribute("userAttr-Double", 45.4567);
                  _moengagePlugin.setUserAttribute(
                      "userAttr-String", "This is a string");
                },
              ),
              new ListTile(
                title: Text("Set UserAttribute Timestamp"),
                onTap: () {
                  _moengagePlugin.setUserAttributeIsoDate(
                      "timeStamp", "2019-12-02T08:26:21.170Z");
                },
              ),
              new ListTile(
                title: Text("Set UserAttribute Location"),
                onTap: () {
                  _moengagePlugin.setUserAttributeLocation(
                      "locationAttr", new MoEGeoLocation(72.8, 53.2));
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
                    _moengagePlugin.startGeofenceMonitoring();
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
                    _moengagePlugin.passFCMPushToken(
                        "fjt-NFxzQey7Y8mSNBig0M:APA91bGRrvQxbgebauzU4xp6yz-uQkNsPk52t1RLn5ZSZK4LTd_jpC0wGKSrI1mUHyRKgmlQbQ8r3Xt1C9aJiBCCx2F9hThJVoONSAf8fkJ31ikPkrGOYkvxcQb1s9zYtoKyCYANdZJq");
                  }),
              new ListTile(
                  title: Text("Android -- PushKit Push Token"),
                  onTap: () {
                    // Token passed here is just for illustration purposes. Please pass the actual token instead.
//                    _moengagePlugin.passPushKitPushToken(
//                        "IQAAAACy0T43AADshvE4JWn5zbicfxAYnljrKzjiHyUytoK-V6U0zmrjsluIB1a0oSybQlTI7_39bHJ3cix_vI6QnEx1_sT1gFULXZtCkjVn93PCdg");
                  }),
              new ListTile(
                  title: Text("Android -- FCM Push Payload"),
                  onTap: () {
                    // this payload is only for illustration purpose. Please pass the actual push payload.
                    var pushPayload = Map<String, String>();
                    pushPayload.putIfAbsent("push_from", () => "moengage");
                    pushPayload.putIfAbsent("gcm_title", () => "Title");
                    pushPayload.putIfAbsent(
                        "gcm_notificationType", () => "normal notification");
                    pushPayload.putIfAbsent("gcm_alert", () => "Message");
                    pushPayload.putIfAbsent("gcm_campaign_id", () => "1234568");
                    pushPayload.putIfAbsent("gcm_activityName",
                        () => "com.moengage.sampleapp.MainActivity");
                    _moengagePlugin.passFCMPushPayload(pushPayload);
                  }),
              new ListTile(
                  title: Text("Opt-Out Data"),
                  onTap: () {
                    _moengagePlugin.optOutDataTracking(true);
                  }),
              new ListTile(
                  title: Text("Opt-In Data"),
                  onTap: () {
                    _moengagePlugin.optOutDataTracking(false);
                  }),
/*              new ListTile(
                  title: Text("Enable logs"),
                  onTap: () {
                    _moengagePlugin.enableSDKLogs();
                  }),*/
              new ListTile(
                title: Text("Logout"),
                onTap: () {
                  _moengagePlugin.logout();
                },
              ),
              // new ListTile(
              //   title: Text("Un Clicked Count"),
              //   onTap: () async {
              //     int count = await _moEngageInbox.getUnClickedCount();
              //     print("Un-clicked Count " + count.toString());
              //   },
              // ),
              // new ListTile(
              //   title: Text("Get all messages"),
              //   onTap: () async {
              //     InboxData? data = await _moEngageInbox.fetchAllMessages();
              //     if (data != null && data.messages.length > 0) {
              //       InboxMessage message = data.messages[0];
              //       _moEngageInbox.trackMessageClicked(message);
              //       _moEngageInbox.deleteMessage(message);
              //
              //       for (final message in data.messages) {
              //         print(message.toString());
              //       }
              //     }
              //   },
              // ),
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
              )
            ]).toList(),
          ),
        ),
      ),
    );
  }
}
