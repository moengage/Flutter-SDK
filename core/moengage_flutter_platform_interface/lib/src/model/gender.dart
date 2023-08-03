import '../constants.dart';

/// User attribute Gender options
enum MoEGender {
  /// User Gender Male
  male,

  /// User Gender Female
  female,

  /// User Gender Other
  other
}

/// Convert Gender to String
String genderToString(MoEGender gender) {
  switch (gender) {
    case MoEGender.male:
      return genderMale;
    case MoEGender.female:
      return genderFemale;
    case MoEGender.other:
      return genderOther;
  }
}
