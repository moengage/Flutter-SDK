/// User Attribute Location Attribute
class MoEGeoLocation {
  /// [MoEGeoLocation] Constructor
  MoEGeoLocation(this.latitude, this.longitude);

  ///Latitude of location
  double latitude;

  /// Longitude of location
  double longitude;

  Map<String, double> toMap() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  @override
  String toString() {
    return '{\nlatitude: $latitude\nlatitude: $longitude\n}';
  }
}
