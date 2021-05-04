class MoEGeoLocation {
  double latitude;
  double longitude;

  MoEGeoLocation(this.latitude, this.longitude);

  Map<String, double> toMap() {
    return {"latitude": this.latitude, "longitude": this.longitude};
  }

  String toString() {
    return "{\n" +
        "latitude:" +
        latitude.toString() +
        "\n" +
        "latitude:" +
        longitude.toString() +
        "\n" +
        "}";
  }
}
