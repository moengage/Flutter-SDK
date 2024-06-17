# moengage\_flutter\_web

The Web implementation of [`moengage_flutter`][1].

## Usage

This package is [endorsed][2], which means you can simply use `moengage_flutter`
normally. This package will be automatically included in your app when you do,
so you do not need to add it to your `pubspec.yaml`.

However, if you `import` this package to use any of its APIs directly, you
should add it to your `pubspec.yaml` as usual.

[1]: https://pub.dev/packages/moengage_flutter
[2]: https://flutter.dev/docs/development/packages-and-plugins/developing-packages#endorsed-federated-plugin

If events and/or user attributes are unable to get tracked (in case of all-user billing or after user subscribes in push-subscriber billing), then you can call moengageInitialiser function at a delay based on your load time-

```
// import this dependency at the top of the file
import 'dart:async';

/* inside initialise function, replace moengageInitialiser(); with Timer(const Duration(seconds: 5), moengageInitialiser); */
JsObject? _moengage;
@override
void initialise(MoEInitConfig moEInitConfig, String appId) {
    Logger.d('initialise() : Initialising MoEngage web SDK');
    Timer(const Duration(seconds: 5), moengageInitialiser); // 5 seconds delay, just for example
}
```