// ignore_for_file: public_member_api_docs

import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart'
    show MoEProperties;

extension MoEEvent on MoEProperties {
  Map<String, dynamic> getNormalizedEventAttributeJson() {
    final Map<String, dynamic> dateTimeAttributesParsed = {};
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
String _keyIsNonInteractive = 'isNonInteractive';
