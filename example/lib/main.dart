import 'package:flutter/material.dart';
import 'dart:async';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter/geo_location.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/gender.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/push_campaign.dart';
import 'package:moengage_flutter/inapp_campaign.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MoEngageFlutter _moengagePlugin = MoEngageFlutter();

  void _onPushClick(PushCampaign message) {
    print("This is a push click callback from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppClick(InAppCampaign message) {
    print("This is a inapp click callback from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppShown(InAppCampaign message) {
    print("This is a callback on inapp shown from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppDismiss(InAppCampaign message) {
    print("This is a callback on inapp dismiss from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppCustomAction(InAppCampaign message) {
    print("This is a callback on inapp custom action from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppSelfHandle(InAppCampaign message) {
    print("This is a callback on inapp self handle from native to flutter. Payload " +
        message.toString());
    _moengagePlugin.selfHandledShown(message);
    _moengagePlugin.selfHandledClicked(message);
    _moengagePlugin.selfHandledDismissed(message);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _moengagePlugin.initialise();
    _moengagePlugin.setUpPushCallbacks(_onPushClick);
    _moengagePlugin.setUpInAppCallbacks(
      onInAppClick: _onInAppClick,
      onInAppShown: _onInAppShown,
      onInAppDismiss: _onInAppDismiss,
      onInAppCustomAction: _onInAppCustomAction,
      onInAppSelfHandle: _onInAppSelfHandle
    );

    _moengagePlugin.enableSDKLogs();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new ListView(
            children: ListTile.divideTiles(context: context, tiles: [
              new ListTile(
                  title: new Text("Track Event with Attributes"),
                  onTap: () {
                    var details = MoEProperties();
                    details
                        .addInteger("temp", 567)
                        .addBoolean("temp1", true)
                        .addDouble("temp2", 12.30)
                        .addString("stringAttr", "string val")
                        .addAttribute("attrName1", "attrVal")
                        .addAttribute("attrName2", false)
                        .addAttribute("attrName3", 123563563)
                        .addAttribute("arrayAttr", ["str1", 12.8, "str2", 123, true,
                      {"hello": "testing"}])
                        .setNonInteractiveEvent()
                        .addAttribute(
                            "location1", new MoEGeoLocation(12.1, 77.18))
                        .addLocation(
                            "location2", new MoEGeoLocation(12.2, 77.28))
                        .addLocation(
                            "location3", new MoEGeoLocation(12.3, 77.38))
                        .addISODateTime("dateTime1", "2019-12-02T08:26:21.170Z")
                        .addISODateTime(
                            "dateTime2", "2019-12-06T08:26:21.170Z");
                    _moengagePlugin.trackEvent('event flutter 01', details);
                  }),
              new ListTile(
                  title: Text("Track Only Event"),
                  onTap: () {
                    _moengagePlugin.trackEvent("testEvent", MoEProperties());
                  }),
              new ListTile(
                  title: new Text("Set Unique Id"),
                  onTap: () {
                    _moengagePlugin.setUniqueId('mobiledevs@moengage.com');
                  }),
              new ListTile(
                  title: new Text("Set UserName"),
                  onTap: () {
                    _moengagePlugin.setUserName('MoEngage Inc');
                  }),
              new ListTile(
                  title: new Text("Set FirstName"),
                  onTap: () {
                    _moengagePlugin.setFirstName("MoEngage");
                  }),
              new ListTile(
                  title: new Text("Set LastName"),
                  onTap: () {
                    _moengagePlugin.setLastName("Inc");
                  }),
              new ListTile(
                  title: new Text("Set Email-Id"),
                  onTap: () {
                    _moengagePlugin.setEmail("mobiledevs@moengage.com");
                  }),
              new ListTile(
                  title: new Text("Set Phone Number"),
                  onTap: () {
                    _moengagePlugin.setPhoneNumber("1234567890");
                  }),
              new ListTile(
                  title: new Text("Set Gender"),
                  onTap: () {
                    _moengagePlugin.setGender(MoEGender.male);
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
                onTap: () {
                  _moengagePlugin.setAlias('testUser@moengage.com');
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
                  title: Text("Show InApp"),
                  onTap: () {
                    _moengagePlugin.showInApp();
                  }),
              new ListTile(
                  title: Text("Show Self Handled InApp"),
                  onTap: () {
                    _moengagePlugin.getSelfHandledInApp();
                  }),
              new ListTile(
                  title: Text("Set InApp Contexts"),
                  onTap: () {
                    _moengagePlugin.setCurrentContext(["HOME","SETTINGS"]);
                  }),
              new ListTile(
                  title: Text("Reset Contexts"),
                  onTap: () {
                    _moengagePlugin.resetCurrentContext();
                  }),
              new ListTile(
                  title: Text("Push Token"),
                  onTap: () {
                    // Token passed here is just for illustration purposes. Please pass the actual token instead.
                    _moengagePlugin.passFCMPushToken("dummyToken");
                  }),
              new ListTile(
                  title: Text("Push Payload"),
                  onTap: () {
                    // this payload is only for illustration purpose. Please pass the actual push payload.
                    var pushPayload = Map<String, String>();
                    pushPayload.putIfAbsent("push_from", () => "moengage");
                    pushPayload.putIfAbsent("gcm_title", () => "Title");
                    pushPayload.putIfAbsent(
                        "gcm_notificationType", () => "normal notification");
                    pushPayload.putIfAbsent("gcm_alert", () => "Message");
                    pushPayload.putIfAbsent("gcm_campaign_id", () => "123456");
                    pushPayload.putIfAbsent("gcm_activityName",
                        () => "com.moe.pushlibrary.activities.MoEActivity");
                    _moengagePlugin.passFCMPushPayload(pushPayload);
                  }),
              new ListTile(
                  title: Text("Opt-Out Data, Push, InApp"),
                  onTap: () {
                    _moengagePlugin.optOutDataTracking(true);
                    _moengagePlugin.optOutPushTracking(true);
                    _moengagePlugin.optOutInAppTracking(true);
                  }),
              new ListTile(
                  title: Text("Opt-In Data, Push, InApp"),
                  onTap: () {
                    _moengagePlugin.optOutDataTracking(false);
                    _moengagePlugin.optOutPushTracking(false);
                    _moengagePlugin.optOutInAppTracking(false);
                  }),
              new ListTile(
                  title: Text("Enable logs"),
                  onTap: () {
                    _moengagePlugin.enableSDKLogs();
                  }),
              new ListTile(
                title: Text("Logout"),
                onTap: () {
                  _moengagePlugin.logout();
                },
              ),
            ]).toList(),
          ),
        ),
      ),
    );
  }
}
