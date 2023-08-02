import 'package:moengage_flutter_platform_interface/src/model/properties.dart';

extension MoEEvent on MoEProperties {
  Map<String, dynamic> getNormalizedEventAttributeJson() {
    final Map dateTimeAttributesParsed = {};
    dateTimeAttributes.forEach(
      (String k, String v) => dateTimeAttributesParsed[k] = {
        keyTimeStampWeb: DateTime.parse(v).millisecondsSinceEpoch.toString()
      },
    );
    return {
      _keyEventAttributes: {
        ...generalAttributes,
        ...locationAttributes,
        ...dateTimeAttributesParsed
      },
      _keyIsNonInteractive: isNonInteractive
    };
  }
}

String keyTimeStampWeb = 'dartTimeStamp';
String keyPayload = 'payload';
String keyKvPair = 'kvPair';
String _keyEventAttributes = 'eventAttributes';
String _keyGeneralAttributes = 'generalAttributes';
String _keyLocationAttributes = 'locationAttributes';
String _keyDateTimeAttributes = 'dateTimeAttributes';
String _keyIsNonInteractive = 'isNonInteractive';
