import 'dart:convert';
import '../../moengage_flutter_platform_interface.dart';

/// Helper class to track event attributes.
class MoEProperties {
  /// [MoEProperties] Constructor
  MoEProperties()
      : generalAttributes = {},
        locationAttributes = {},
        dateTimeAttributes = {},
        isNonInteractive = false;

  /// General Attribute
  Map<String, dynamic> generalAttributes;

  /// Location Attribute
  Map<String, Map<String, double>> locationAttributes;

  /// Date Time Attributes
  Map<String, String> dateTimeAttributes;

  /// Non Interactive Event Flag
  bool isNonInteractive;

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

  /// Marks an event as non-interactive.
  MoEProperties setNonInteractiveEvent() {
    isNonInteractive = true;
    return this;
  }

  /// Get Event Attributes [Map]
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
    final isPrimitiveType = attributeType is String ||
        attributeType is int ||
        attributeType is double ||
        attributeType is num ||
        attributeType is bool ||
        attributeType is MoEGeoLocation ||
        attributeType is List<dynamic> ||
        attributeType is Map<String, dynamic>;
    return isPrimitiveType;
  }

  /// Check whether array type is Supported. It can be either primitive array type
  /// or it can be JSON or Array.
  bool _isAcceptedArrayType(dynamic attributeType) {
    final isPrimitiveType = attributeType is String ||
        attributeType is int ||
        attributeType is double ||
        attributeType is num ||
        attributeType is bool;
    return isPrimitiveType || _isValidJson(attributeType);
  }

  void _addAttribute(String key, dynamic value) {
    if (_isAttributeNameEmpty(key)) {
      return;
    }
    if (value is String || value is int || value is double || value is bool) {
      generalAttributes.putIfAbsent(key, () => value);
    } else if (value is MoEGeoLocation) {
      locationAttributes.putIfAbsent(key, () => value.toMap());
    } else if (value is Iterable) {
      final List<dynamic> typeCheckedArray = [];
      for (final dynamic val in value) {
        if (!_isAcceptedArrayType(val)) {
          continue;
        }
        typeCheckedArray.add(val);
      }
      generalAttributes.putIfAbsent(key, () => typeCheckedArray);
    } else if (_isValidJson(value)) {
      // If is a valid json, we would track. Applicable Map<> types
      generalAttributes.putIfAbsent(key, () => value);
    }
  }

  /// Returns true if `dynamic` object is valid json otherwise false.
  bool _isValidJson(dynamic attribute) {
    try {
      jsonEncode(attribute);
      return true;
    } catch (e) {
      Logger.e('Attribute with value $attribute is not supported');
      return false;
    }
  }

  final String _keyEventAttributes = 'eventAttributes';
  final String _keyGeneralAttributes = 'generalAttributes';
  final String _keyLocationAttributes = 'locationAttributes';
  final String _keyDateTimeAttributes = 'dateTimeAttributes';
  final String _keyIsNonInteractive = 'isNonInteractive';
}
