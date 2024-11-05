/// Account Meta
class AccountMeta {
  /// [AccountMeta] Constructor
  AccountMeta(this.appId);

  /// MoEngage AppId
  String appId;

  @override
  String toString() {
    return '{\nappId: $appId\n}';
  }
}
