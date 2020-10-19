import 'constants.dart';

enum MoEAttributeType { general, timestamp, location }

String moEAttributeTypeToString(MoEAttributeType type) {
  String typeStr;
  switch(type) {
    case MoEAttributeType.general:
      typeStr = userAttrTypeGeneral;
      break;
    case MoEAttributeType.timestamp:
      typeStr = userAttrTypeTimestamp;
      break;
    case MoEAttributeType.location:
      typeStr = userAttrTypeLocation;
      break;
  }
  return typeStr;
}

