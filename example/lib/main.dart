// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_geofence/moengage_geofence.dart';
import 'package:moengage_inbox/moengage_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'cards/cards_home.dart';
import 'second_page.dart';
import 'utils.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  runApp(const MaterialApp(home: MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.toMap()}');
}

const String tag = 'MoeExample_';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final MoEngageFlutter _moengagePlugin = MoEngageFlutter(
      'DAO6UGZ73D9RTK8B5W96TPYN',
      moEInitConfig: MoEInitConfig(
          pushConfig:
              PushConfig(shouldDeliverCallbackOnForegroundClick: true)));
  final MoEngageGeofence _moEngageGeofence =
      MoEngageGeofence('DAO6UGZ73D9RTK8B5W96TPYN');
  final MoEngageInbox _moEngageInbox =
      MoEngageInbox('DAO6UGZ73D9RTK8B5W96TPYN');

  void _onPushClick(PushCampaignData message) {
    debugPrint(
        '$tag Main : _onPushClick(): This is a push click callback from native to flutter. Payload $message');
    if (message.data.selfHandledPushRedirection) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const SecondPage()));
    }
  }

  void _onInAppClick(ClickData message) {
    debugPrint(
        '$tag Main : _onInAppClick() : This is a inapp click callback from native to flutter. Payload $message');
  }

  void _onInAppShown(InAppData message) {
    debugPrint(
        '$tag Main : _onInAppShown() : This is a callback on inapp shown from native to flutter. Payload $message');
  }

  void _onInAppDismiss(InAppData message) {
    debugPrint(
        '$tag Main : _onInAppDismiss() : This is a callback on inapp dismiss from native to flutter. Payload $message');
  }

  Future<void> _onInAppSelfHandle(SelfHandledCampaignData message) async {
    debugPrint(
        '$tag Main : _onInAppSelfHandle() : This is a callback on inapp self handle from native to flutter. Payload $message');
    final SelfHandledActions? action =
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
      default:
        break;
    }
  }

  void _onPushTokenGenerated(PushTokenData pushToken) {
    debugPrint(
        '$tag Main : _onPushTokenGenerated() : This is callback on push token generated from native to flutter: PushToken: $pushToken');
  }

  void _permissionCallbackHandler(PermissionResultData data) {
    debugPrint('$tag Permission Result: $data');
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('$tag initState() : start ');
    _moengagePlugin.setPushClickCallbackHandler(_onPushClick);
    _moengagePlugin.setInAppClickHandler(_onInAppClick);
    _moengagePlugin.setInAppShownCallbackHandler(_onInAppShown);
    _moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismiss);
    _moengagePlugin.setSelfHandledInAppHandler(_onInAppSelfHandle);
    _moengagePlugin.setPushTokenCallbackHandler(_onPushTokenGenerated);
    _moengagePlugin.setPermissionCallbackHandler(_permissionCallbackHandler);
    _moengagePlugin.configureLogs(LogLevel.VERBOSE);
    _moengagePlugin.initialise();
    debugPrint('initState() : end ');
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    //Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
  }

  late BuildContext buildContext;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _moengagePlugin.initialise();
    }
    debugPrint('Application Lifecycle Changed - $state');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$tag Main : build() ');
    buildContext = context;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _moengagePlugin.onOrientationChanged();
              },
              child: const Text('Orientation Change'),
            ),
          ],
        ),
        body: Center(
          child: ListView(
            children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                title: const Text('GoTo Cards'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const CardsHome()));
                },
              ),
              ListTile(
                  title: const Text('Track Event with Attributes'),
                  onTap: () async {
                    MoEProperties details = MoEProperties();
                    details
                        .addAttribute('temp', 567)
                        .addAttribute('temp1', true)
                        .addAttribute('temp2', 12.30)
                        .addAttribute('stringAttr', 'string val')
                        .addAttribute('attrName1', 'attrVal')
                        .addAttribute('attrName2', false)
                        .addAttribute('attrName3', 123563563)
                        .addAttribute('arrayAttr', [
                          'str1',
                          12.8,
                          'str2',
                          123,
                          true,
                          {'hello': 'testing'}
                        ])
                        .setNonInteractiveEvent()
                        .addAttribute('location1', MoEGeoLocation(12.1, 77.18))
                        .addAttribute('location2', MoEGeoLocation(12.2, 77.28))
                        .addAttribute('location3', MoEGeoLocation(12.3, 77.38))
                        .addISODateTime('dateTime1', '2019-12-02T08:26:21.170Z')
                        .addISODateTime(
                            'dateTime2', '2019-12-06T08:26:21.170Z');
                    final String value =
                        await asyncInputDialog(context, 'Event name');
                    debugPrint('$tag Main: Event name : $value');
                    _moengagePlugin.trackEvent(value, details);
                  }),
              ListTile(
                  title: const Text('Track Interactive Event with Attributes'),
                  onTap: () async {
                    MoEProperties details = MoEProperties();
                    details
                        .addAttribute('temp', 567)
                        .addAttribute('temp1', true)
                        .addAttribute('temp2', 12.30)
                        .addAttribute('stringAttr', 'string val')
                        .addAttribute('attrName1', 'attrVal')
                        .addAttribute('attrName2', false)
                        .addAttribute('attrName3', 123563563)
                        .addAttribute('arrayAttr', [
                          'str1',
                          12.8,
                          'str2',
                          123,
                          true,
                          {'hello': 'testing'}
                        ])
                        .addAttribute('location1', MoEGeoLocation(12.1, 77.18))
                        .addAttribute('location2', MoEGeoLocation(12.2, 77.28))
                        .addAttribute('location3', MoEGeoLocation(12.3, 77.38))
                        .addISODateTime('dateTime1', '2019-12-02T08:26:21.170Z')
                        .addISODateTime(
                            'dateTime2', '2019-12-06T08:26:21.170Z');
                    final String value =
                        await asyncInputDialog(context, 'Event name');
                    debugPrint('$tag Main: Event name : $value');
                    _moengagePlugin.trackEvent(value, details);
                  }),
              ListTile(
                  title: const Text('Track Only Event'),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, 'Event name');
                    debugPrint('$tag Main: Event name : $value');
                    _moengagePlugin.trackEvent(value);
                  }),
              ListTile(
                  title: const Text('Set Unique Id'),
                  onTap: () async {
//                    _moengagePlugin.setUniqueId(null);
                    final String value =
                        await asyncInputDialog(context, 'Unique Id');
                    debugPrint('$tag Main: UniqueId: $value');
                    _moengagePlugin.setUniqueId(value);
                  }),
              ListTile(
                  title: const Text('Set UserName'),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, 'User Name');
                    debugPrint('$tag Main: UserName: $value');
                    _moengagePlugin.setUserName(value);
                  }),
              ListTile(
                  title: const Text('Set FirstName'),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, 'First Name');
                    debugPrint('$tag Main: FisrtName: $value');
                    _moengagePlugin.setFirstName(value);
                  }),
              ListTile(
                  title: const Text('Set LastName'),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, 'Last Name');
                    debugPrint('$tag Main: Last Name: $value');
                    _moengagePlugin.setLastName(value);
                  }),
              ListTile(
                  title: const Text('Set Email-Id'),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, 'EmailId');
                    debugPrint('$tag Main: EmailId: $value');
                    _moengagePlugin.setEmail(value);
                  }),
              ListTile(
                  title: const Text('Set Phone Number'),
                  onTap: () async {
                    final String value =
                        await asyncInputDialog(context, 'Phone Number');
                    debugPrint('$tag Main: Phone Number: $value');
                    _moengagePlugin.setPhoneNumber(value);
                  }),
              ListTile(
                  title: const Text('Set Gender'),
                  onTap: () {
                    _moengagePlugin.setGender(MoEGender.female);
                  }),
              ListTile(
                  title: const Text('Set Location'),
                  onTap: () {
                    _moengagePlugin.setLocation(MoEGeoLocation(23.1, 21.2));
                  }),
              ListTile(
                  title: const Text('Set Birthday'),
                  onTap: () {
                    _moengagePlugin.setBirthDate('2019-12-02T08:26:21.170Z');
                  }),
              ListTile(
                title: const Text('Set Alias'),
                onTap: () async {
                  final String value = await asyncInputDialog(context, 'Alias');
                  debugPrint('$tag Main: Alias : $value');
                  _moengagePlugin.setAlias(value);
                },
              ),
              ListTile(
                title: const Text('Set Custom User Attributes'),
                onTap: () {
                  const num number = 15.4567;
                  _moengagePlugin.setUserAttribute('userAttr-bool', true);
                  _moengagePlugin.setUserAttribute('userAttr-int', 1443322);
                  _moengagePlugin.setUserAttribute('userAttr-Double', 45.4567);
                  _moengagePlugin.setUserAttribute('userAttr-Number', number);
                  _moengagePlugin.setUserAttribute(
                      'userAttr-String', 'This is a string');
                  _moengagePlugin
                      .setUserAttribute('userAttr-array-int', [1, 2, 3, 4, 5]);
                  _moengagePlugin.setUserAttribute(
                      'userAttr-array-Double', [1.0, 1.5, 0.01, 5.45]);
                  _moengagePlugin.setUserAttribute(
                      'userAttr-array-Number', [1.0, 1, 0.01, 5.45]);
                  _moengagePlugin.setUserAttribute('userAttr-array-String',
                      ['This', 'is', 'an', 'array', 'of', 'strings']);
                  // not tacked cases
                  _moengagePlugin.setUserAttribute(
                      'userAttr-array-mixed', ['not', 1, 'tracked']);
                  _moengagePlugin
                      .setUserAttribute('userAttr-array-Bool', [true, false]);
                },
              ),
              ListTile(
                title: const Text('Set UserAttribute Timestamp'),
                onTap: () {
                  _moengagePlugin.setUserAttributeIsoDate(
                      'timeStamp', '2019-12-02T08:26:21.170Z');
                },
              ),
              ListTile(
                title: const Text('Set UserAttribute Location'),
                onTap: () {
                  _moengagePlugin.setUserAttributeLocation(
                      'locationAttr', MoEGeoLocation(72.8, 53.2));
                },
              ),
              ListTile(
                  title: const Text('App Status - Install'),
                  onTap: () {
                    _moengagePlugin.setAppStatus(MoEAppStatus.install);
                  }),
              ListTile(
                  title: const Text('App Status - Update'),
                  onTap: () {
                    _moengagePlugin.setAppStatus(MoEAppStatus.update);
                  }),
              ListTile(
                  title: const Text('iOS -- Register For Push'),
                  onTap: () {
                    _moengagePlugin.registerForPushNotification();
                  }),
              ListTile(
                  title: const Text('Start Geofence Monitoring'),
                  onTap: () {
                    debugPrint('Start GeoFence Monitoring - Flutter');
                    _moEngageGeofence.startGeofenceMonitoring();
                  }),
              ListTile(
                  title: const Text('Stop Geofence Monitoring'),
                  onTap: () {
                    debugPrint('Stop GeoFence Monitoring - Flutter');
                    _moEngageGeofence.stopGeofenceMonitoring();
                  }),
              ListTile(
                title: const Text('Request Location Permission'),
                onTap: () async {
                  Map<Permission, PermissionStatus> statuses =
                      await [Permission.locationAlways].request();
                  debugPrint(statuses.toString());
                },
              ),
              ListTile(
                  title: const Text('Show InApp'),
                  onTap: () {
                    _moengagePlugin.showInApp();
                  }),
              ListTile(
                  title: const Text('Show Self Handled InApp'),
                  onTap: () {
                    buildContext = context;
                    _moengagePlugin.getSelfHandledInApp();
                  }),
              ListTile(
                  title: const Text('Set InApp Contexts'),
                  onTap: () {
                    _moengagePlugin.setCurrentContext(['HOME', 'SETTINGS']);
                  }),
              ListTile(
                  title: const Text('Reset Contexts'),
                  onTap: () {
                    _moengagePlugin.resetCurrentContext();
                  }),
              ListTile(
                  title: const Text('Android -- FCM Push Token'),
                  onTap: () {
//                     Token passed here is just for illustration purposes. Please pass the actual token instead.
//                    _moengagePlugin.passFCMPushToken(null);
                    _moengagePlugin.passFCMPushToken(
                        'dTFauhaKRgiRpBk_evwffB:APA91bEGxaY53AlYMpjqxgNd7GK_dWlwrqvKLF7MvaAeVFYyDYyXlJ7JuoItnVir0zLl53TXZcStdeUvGpeorhEfOtPk6ML4anpwoOEak16bhS0455X-yFY5VqZdrZ58dfaA16wyXbhH');
                  }),
              ListTile(
                  title: const Text('Android -- PushKit Push Token'),
                  onTap: () {
                    // Token passed here is just for illustration purposes. Please pass the actual token instead.
                    _moengagePlugin.passPushKitPushToken(
                        'IQAAAACy0T43AABSrIoiO4BN6XNORkptaWgyxTTEcIS9EgA1PUeNdYcAeBP6Ea-X6oIsWv5j7HKA8Hdna_JBMpNiVp_B8xR8HYEHC2Yw5yhE69AyaQ');
                  }),
              ListTile(
                  title: const Text('Android -- FCM Push Payload'),
                  onTap: () {
                    // this payload is only for illustration purpose. Please pass the actual push payload.
                    Map<String, String> pushPayload = <String, String>{};
                    pushPayload.putIfAbsent('push_from', () => 'moengage');
                    pushPayload.putIfAbsent('gcm_title', () => 'Title');
                    pushPayload.putIfAbsent(
                        'moe_app_id', () => 'DAO6UGZ73D9RTK8B5W96TPYN');
                    pushPayload.putIfAbsent(
                        'gcm_notificationType', () => 'normal notification');
                    pushPayload.putIfAbsent('gcm_alert', () => 'Message');

                    pushPayload.putIfAbsent('gcm_campaign_id',
                        () => DateTime.now().millisecondsSinceEpoch.toString());
                    pushPayload.putIfAbsent('gcm_activityName',
                        () => 'com.moengage.sampleapp.MainActivity');
                    _moengagePlugin.passFCMPushPayload(pushPayload);
                  }),
              ListTile(
                  title: const Text('Enable data tracking'),
                  onTap: () {
                    _moengagePlugin.enableDataTracking();
                  }),
              ListTile(
                  title: const Text('Disable data tracking'),
                  onTap: () {
                    _moengagePlugin.disableDataTracking();
                  }),
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  _moengagePlugin.logout();
                },
              ),
              ListTile(
                title: const Text('Inbox: Un-Clicked Count'),
                onTap: () async {
                  int count = await _moEngageInbox.getUnClickedCount();
                  debugPrint('$tag Main : Un-clicked Count $count');
                },
              ),
              ListTile(
                title: const Text('Inbox: Get all messages'),
                onTap: () async {
                  InboxData? data = await _moEngageInbox.fetchAllMessages();
                  if (data != null) {
                    debugPrint(
                        '$tag Main : Inbox Messages count: ${data.messages.length}');
                    if (data.messages.isNotEmpty) {
                      for (final InboxMessage message in data.messages) {
                        debugPrint('$tag Main : Inbox Messages $message');
                      }
                    }
                  }
                },
              ),
              ListTile(
                title: const Text('Inbox: Track all messages'),
                onTap: () async {
                  InboxData? data = await _moEngageInbox.fetchAllMessages();
                  if (data != null) {
                    debugPrint(
                        '$tag Main : Inbox Messages count: ${data.messages.length}');
                    if (data.messages.isNotEmpty) {
                      for (final InboxMessage message in data.messages) {
                        debugPrint(
                            '$tag Main : Tracking inbox message: $message');
                        _moEngageInbox.trackMessageClicked(message);
                      }
                    }
                  }
                },
              ),
              ListTile(
                title: const Text('Inbox: Delete all messages'),
                onTap: () async {
                  InboxData? data = await _moEngageInbox.fetchAllMessages();
                  if (data != null) {
                    debugPrint(
                        '$tag Main : Inbox Messages count: ${data.messages.length}');
                    if (data.messages.isNotEmpty) {
                      for (final InboxMessage message in data.messages) {
                        debugPrint(
                            '$tag Main : Deleting inbox message: $message');
                        _moEngageInbox.deleteMessage(message);
                      }
                    }
                  }
                },
              ),
              ListTile(
                title: const Text('Enable Sdk'),
                onTap: () async {
                  _moengagePlugin.enableSdk();
                },
              ),
              ListTile(
                title: const Text('Disable Sdk'),
                onTap: () async {
                  _moengagePlugin.disableSdk();
                },
              ),
              ListTile(
                title: const Text('Android- Enable Android Id'),
                onTap: () async {
                  _moengagePlugin.enableAndroidIdTracking();
                },
              ),
              ListTile(
                title: const Text('Android- Disable Android Id'),
                onTap: () async {
                  _moengagePlugin.disableAndroidIdTracking();
                },
              ),
              ListTile(
                title: const Text('Android- Enable Ad Id'),
                onTap: () async {
                  _moengagePlugin.enableAdIdTracking();
                },
              ),
              ListTile(
                title: const Text('Android- Disable Ad Id'),
                onTap: () async {
                  _moengagePlugin.disableAdIdTracking();
                },
              ),
              ListTile(
                title: const Text('Android- Navigate to Settings'),
                onTap: () async {
                  _moengagePlugin.navigateToSettingsAndroid();
                },
              ),
              ListTile(
                title: const Text('Android- Request Push Permission'),
                onTap: () async {
                  _moengagePlugin.requestPushPermissionAndroid();
                },
              ),
              ListTile(
                title: const Text('Android- Mock push permission granted'),
                onTap: () async {
                  _moengagePlugin.pushPermissionResponseAndroid(true);
                },
              ),
              ListTile(
                title: const Text('Android- Mock push permission denied'),
                onTap: () async {
                  _moengagePlugin.pushPermissionResponseAndroid(false);
                },
              ),
              ListTile(
                title: const Text('Update Push Permission Request Count'),
                onTap: () async {
                  final String value =
                      await asyncInputDialog(context, 'Push Permission Count');
                  final int pushPermissionCount = int.tryParse(value) ?? 0;
                  _moengagePlugin.updatePushPermissionRequestCountAndroid(
                      pushPermissionCount);
                },
              ),
              ListTile(
                title: const Text('Enable Device Id Tracking'),
                onTap: () async {
                  _moengagePlugin.enableDeviceIdTracking();
                },
              ),
              ListTile(
                title: const Text('Disable Device Id Tracking'),
                onTap: () async {
                  _moengagePlugin.disableDeviceIdTracking();
                },
              ),
              ListTile(
                title: const Text('Delete User - (Android Only)'),
                onTap: () {
                  _moengagePlugin.deleteUser().then((value) {
                    debugPrint('User Deletion Result:  ${value.isSuccess}');
                  }).catchError((onError) {
                    debugPrint('Error Occurred while Deleting User Data');
                  });
                },
              ),
            ]).toList(),
          ),
        ),
      ),
    );
  }
}
