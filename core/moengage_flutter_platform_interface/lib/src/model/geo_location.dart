class MoEGeoLocation {
  MoEGeoLocation(this.latitude, this.longitude);
  double latitude;
  double longitude;

  Map<String, double> toMap() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  @override
  String toString() {
    return '{\nlatitude: ${latitude.toString()}\nlatitude: ${longitude.toString()}\n}';
  }
}
