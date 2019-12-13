import 'package:moengage_flutter/geo_location.dart';

class MoEProperties {
  Map<String, dynamic> generalAttributes;
  Map<String, Map<String, double>> locationAttributes;
  Map<String, String> dateTimeAttributes;
  bool isNonInteractive;

  MoEProperties() {
    generalAttributes = new Map();
    locationAttributes = new Map();
    dateTimeAttributes = new Map();
    isNonInteractive = false;
  }

  MoEProperties addString(String key, String value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    generalAttributes.putIfAbsent(key, () => value);
    return this;
  }

  MoEProperties addInteger(String key, int value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    generalAttributes.putIfAbsent(key, () => value);
    return this;
  }

  MoEProperties addDouble(String key, double value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    generalAttributes.putIfAbsent(key, () => value);
    return this;
  }

  MoEProperties addBoolean(String key, bool value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    generalAttributes.putIfAbsent(key, () => value);
    return this;
  }

  MoEProperties addISODateTime(String key, String value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    dateTimeAttributes.putIfAbsent(key, () => value);
    return this;
  }

  MoEProperties addLocation(String key, MoEGeoLocation location) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    locationAttributes.putIfAbsent(key, () => location.getLocationJson());
    return this;
  }

  MoEProperties setNonInteractiveEvent() {
    this.isNonInteractive = true;
    return this;
  }

  Map<String, dynamic> getEventAttributeJson() {
    return {
      'generalAttributes': this.generalAttributes,
      'locationAttributes': this.locationAttributes,
      'dateTimeAttributes': this.dateTimeAttributes,
      'isNonInteractive': this.isNonInteractive
    };
  }

  bool isAttributeNameEmpty(String name) {
    return name.isEmpty;
  }
}
