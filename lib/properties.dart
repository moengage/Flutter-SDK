import 'package:moengage_flutter/geo_location.dart';

/// Helper class to track event attributes.
class MoEProperties {
  Map<String, dynamic> generalAttributes;
  Map<String, Map<String, double>> locationAttributes;
  Map<String, String> dateTimeAttributes;
  bool isNonInteractive;

  //todo add JSON object and JSONArray

  MoEProperties() {
    generalAttributes = new Map();
    locationAttributes = new Map();
    dateTimeAttributes = new Map();
    isNonInteractive = false;
  }

  /// Adds an event attribute of type String.
  MoEProperties addString(String key, String value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    generalAttributes.putIfAbsent(key, () => value);
    return this;
  }

  /// Adds an event attribute of type integer.
  MoEProperties addInteger(String key, int value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    generalAttributes.putIfAbsent(key, () => value);
    return this;
  }

  /// Adds an event attribute of type double.
  MoEProperties addDouble(String key, double value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    generalAttributes.putIfAbsent(key, () => value);
    return this;
  }

  /// Adds an event attribute of type boolean.
  MoEProperties addBoolean(String key, bool value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    generalAttributes.putIfAbsent(key, () => value);
    return this;
  }

  /// Adds an event attribute of type Date.
  /// Date should be in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  MoEProperties addISODateTime(String key, String value) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    dateTimeAttributes.putIfAbsent(key, () => value);
    return this;
  }

  /// Adds an event attribute of type [MoEGeoLocation].
  MoEProperties addLocation(String key, MoEGeoLocation location) {
    if (isAttributeNameEmpty(key)) {
      return this;
    }
    locationAttributes.putIfAbsent(key, () => location.getLocationJson());
    return this;
  }

  /// Marks an event as non-interactive.
  MoEProperties setNonInteractiveEvent() {
    this.isNonInteractive = true;
    return this;
  }

  Map<String, dynamic> getEventAttributeJson() {
    return {
    "eventAttributes": {
      'generalAttributes': this.generalAttributes,
      'locationAttributes': this.locationAttributes,
      'dateTimeAttributes': this.dateTimeAttributes
    },
      'isNonInteractive': this.isNonInteractive
    };
  }

  bool isAttributeNameEmpty(String name) {
    return name.isEmpty;
  }
}
