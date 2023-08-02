class AccountMeta {
  AccountMeta(this.appId);
  String appId;

  @override
  String toString() {
    return '{\nappId: $appId\n}';
  }
}
