class AccountMeta {
  String appId;

  AccountMeta(this.appId);

  String toString() {
    return "{\n" +
        "appId:" +
        appId +
        "\n" +
        "}";
  }
}