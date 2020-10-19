import 'constants.dart';

enum MoEGender { male, female, other }

String moEGenderToString(MoEGender gender) {
  String genderStr;
  switch(gender) {
    case MoEGender.male:
      genderStr = genderMale;
      break;
    case MoEGender.female:
      genderStr = genderFemale;
      break;
    case MoEGender.other:
      genderStr = genderOther;
      break;
  }
  return genderStr;
}

