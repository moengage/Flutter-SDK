import 'package:flutter/material.dart';
import 'dart:async';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter/geo_location.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/gender.dart';
import 'package:moengage_flutter/app_status.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MoEngageFlutter _moengagePlugin = MoEngageFlutter();

  void _onPushClick(Map<String, dynamic> message) {
    print("This is a push click callback from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppClick(Map<String, dynamic> message) {
    print("This is a inapp click callback from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppShown(Map<String, dynamic> message) {
    print("This is a callback on inapp shown from native to flutter. Payload " +
        message.toString());
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _moengagePlugin.initialise();
    _moengagePlugin.setUpPushCallbacks(_onPushClick);
    _moengagePlugin.setUpInAppCallbacks(
        onInAppClick: _onInAppClick, onInAppShown: _onInAppShown);
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
                        .addInteger("temp", 1)
                        .addBoolean("temp1", true)
                        .addDouble("temp2", 12.30)
                        .setNonInteractiveEvent()
                        .addLocation(
                            "location1", new MoEGeoLocation(12.1, 77.18))
                        .addLocation(
                            "location2", new MoEGeoLocation(12.2, 77.28))
                        .addLocation(
                            "location3", new MoEGeoLocation(12.3, 77.38))
                        .addISODateTime("dateTime1", "2019-12-02T08:26:21.170Z")
                        .addISODateTime(
                            "dateTime2", "2019-12-06T08:26:21.170Z");
                    _moengagePlugin.trackEvent('testEvent', details);
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
                  title: Text("Only Event"),
                  onTap: () {
                    _moengagePlugin.trackEvent("testEvent", null);
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
                title: Text("Set Time"),
                onTap: () {
                  _moengagePlugin.setIsoDate(
                      "timeStamp", "2019-12-02T08:26:21.170Z");
                },
              ),
              new ListTile(
                  title: Text("Push Token"),
                  onTap: () {
                    // Token passed here is just for illustration purposes. Please pass the actual token instead.
                    _moengagePlugin.passPushToken("dummyToken");
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
                    _moengagePlugin.passPushPayload(pushPayload);
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
