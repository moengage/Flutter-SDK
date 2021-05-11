import 'package:moengage_flutter/geo_location.dart';

/// Helper class to track event attributes.
class MoEProperties {
  Map<String, dynamic> generalAttributes;
  Map<String, Map<String, double>> locationAttributes;
  Map<String, String> dateTimeAttributes;
  bool isNonInteractive;

  //todo add JSON object and JSONArray

  MoEProperties()
      : this.generalAttributes = new Map(),
        this.locationAttributes = new Map(),
        this.dateTimeAttributes = new Map(),
        this.isNonInteractive = false;

  /// Adds an event attribute of type String.
  @Deprecated('Use addAttribute() instead')
  MoEProperties addString(String key, String value) {
    _addAttribute(key, value);
    return this;
  }

  /// Adds an event attribute of type integer.
  @Deprecated('Use addAttribute() instead')
  MoEProperties addInteger(String key, int value) {
    _addAttribute(key, value);
    return this;
  }

  /// Adds an event attribute of type double.
  @Deprecated('Use addAttribute() instead')
  MoEProperties addDouble(String key, double value) {
    _addAttribute(key, value);
    return this;
  }

  /// Adds an event attribute of type boolean.
  @Deprecated('Use addAttribute() instead')
  MoEProperties addBoolean(String key, bool value) {
    _addAttribute(key, value);
    return this;
  }

  /// Adds an event attribute of type string, number or boolean.
  MoEProperties addAttribute(String key, dynamic value) {
    if (!_isAcceptedDataType(value)) {
      return this;
    }
    _addAttribute(key, value);
    return this;
  }

  /// Adds an event attribute of type Date.
  /// Date should be in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  MoEProperties addISODateTime(String key, String value) {
    if (_isAttributeNameEmpty(key)) {
      return this;
    }
    dateTimeAttributes.putIfAbsent(key, () => value);
    return this;
  }

  /// Adds an event attribute of type [MoEGeoLocation].
  @Deprecated('Use addAttribute() instead')
  MoEProperties addLocation(String key, MoEGeoLocation location) {
    _addAttribute(key, location);
    return this;
  }

  /// Marks an event as non-interactive.
  MoEProperties setNonInteractiveEvent() {
    this.isNonInteractive = true;
    return this;
  }

  Map<String, dynamic> getEventAttributeJson() {
    return {
      _keyEventAttributes: {
        _keyGeneralAttributes: generalAttributes,
        _keyLocationAttributes: locationAttributes,
        _keyDateTimeAttributes: dateTimeAttributes
      },
      _keyIsNonInteractive: isNonInteractive
    };
  }

  bool _isAttributeNameEmpty(String name) {
    return name.isEmpty;
  }

  bool _isAcceptedDataType(dynamic attributeType) {
    return attributeType is String ||
        attributeType is int ||
        attributeType is double ||
        attributeType is bool ||
        attributeType is MoEGeoLocation ||
        attributeType is List;
  }

  bool _isAcceptedArrayType(dynamic attributeType) {
    return attributeType is String ||
        attributeType is int ||
        attributeType is double;
  }

  void _addAttribute(String key, dynamic value) {
    if (_isAttributeNameEmpty(key)) return;
    if (value is String || value is int || value is double || value is bool) {
      generalAttributes.putIfAbsent(key, () => value);
    } else if (value is MoEGeoLocation) {
      locationAttributes.putIfAbsent(key, () => value.toMap());
    } else if (value is List) {
      List<dynamic> typeCheckedArray = [];
      for (var val in value) {
        if (!_isAcceptedArrayType(val)) continue;
        typeCheckedArray.add(val);
      }
      generalAttributes.putIfAbsent(key, () => typeCheckedArray);
    }
  }

  String _keyEventAttributes = "eventAttributes";
  String _keyGeneralAttributes = "generalAttributes";
  String _keyLocationAttributes = "locationAttributes";
  String _keyDateTimeAttributes = "dateTimeAttributes";
  String _keyIsNonInteractive = "isNonInteractive";
}
