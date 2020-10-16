enum MoEGender { male, female, other }

String moEGenderToString(MoEGender gender) {
  return '$gender'
      .split('.')
      .last;
}

