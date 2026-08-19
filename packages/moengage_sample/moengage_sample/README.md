# MoEngage Sample Plugin

Sample Plugin scaffold for MoEngage Platform. This module is a lightweight, pure-Dart reference package used to:

- serve as a template for scaffolding new Flutter SDK modules, and
- validate that the CI pipeline and the pub.dev release pipeline correctly support a brand-new module being added to the workspace.

It is not intended to be integrated into production applications.

## SDK Installation

To add the MoEngage Flutter SDK to your application, edit your application's `pubspec.yaml` file and add the below dependency to it:

![Download](https://img.shields.io/pub/v/moengage_sample.svg)

```yaml
dependencies:
  moengage_sample: $latestSdkVersion
```
replace `$latestSdkVersion` with the latest SDK version.

Run flutter packages get to install the SDK.

Note: This plugin is dependent on the `moengage_flutter` plugin. Make sure you have installed the `moengage_flutter` plugin as well.

## Usage

```dart
import 'package:moengage_sample/moengage_sample.dart';

final sample = MoEngageSample(appId);
final greeting = sample.greet();
```
