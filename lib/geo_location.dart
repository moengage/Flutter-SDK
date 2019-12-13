class MoEGeoLocation {
  double latitude;
  double longitude;

  MoEGeoLocation(double latitude, double longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  Map<String, double> getLocationJson() {
    return {"latitude": this.latitude, "longitude": this.longitude};
  }
}
