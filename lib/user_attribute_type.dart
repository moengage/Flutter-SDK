enum MoEAttributeType { general, timestamp, location }

String moEAttributeTypeToString(MoEAttributeType type) {
  return '$type'
      .split('.')
      .last;
}

