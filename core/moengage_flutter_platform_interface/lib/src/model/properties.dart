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
    final isPrimitiveType = isSupportedPrimitiveType(attributeType) ||
        attributeType is MoEGeoLocation ||
        attributeType is List<dynamic> ||
        attributeType is Map<String, dynamic>;
    return isPrimitiveType;
  }

  void _addAttribute(String key, dynamic value) {
    if (_isAttributeNameEmpty(key)) {
      return;
    }
    if (isSupportedPrimitiveType(value)) {
      generalAttributes[key] = value;
    } else if (value is Iterable) {
      generalAttributes[key] = filterIterableWithSupportedTypes(value);
    } else if (value is Map<String, dynamic>) {
      generalAttributes[key] = filterMapWithSupportedTypes(value);
    } else if (value is MoEGeoLocation) {
      locationAttributes[key] = value.toMap();
    } else {
      Logger.w('Unsupported Type/Value for the Key: $key with value : $value');
    }
  }

  final String _keyEventAttributes = 'eventAttributes';
  final String _keyGeneralAttributes = 'generalAttributes';
  final String _keyLocationAttributes = 'locationAttributes';
  final String _keyDateTimeAttributes = 'dateTimeAttributes';
  final String _keyIsNonInteractive = 'isNonInteractive';
}
