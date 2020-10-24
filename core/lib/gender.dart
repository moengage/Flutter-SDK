import 'package:moengage_flutter/constants.dart';

enum MoEGender { male, female, other }

String genderToString(MoEGender gender) {
  switch (gender) {
    case MoEGender.male:
      return genderMale;
    case MoEGender.female:
      return genderFemale;
    case MoEGender.other:
      return genderOther;
  }
  return "";
}
