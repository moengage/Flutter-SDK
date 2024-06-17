import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

void main() {
  final MoEProperties properties = MoEProperties()
      .addAttribute('string', 'Mark')
      .addAttribute('int', 300)
      .addAttribute('double', 60.5)
      .addAttribute('bool', false)
      .addAttribute('my_location', MoEGeoLocation(1.2, 2.3))
      .addAttribute('second_location', MoEGeoLocation(201.2, 892.3))
      .addISODateTime('date', '2011-11-02T02:50:12.208Z');

}
