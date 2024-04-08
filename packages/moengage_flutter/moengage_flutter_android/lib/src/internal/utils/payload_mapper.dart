import 'dart:convert';

import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

/// Payload Mapper Util Class to convert JSON Payloads to Model Class
/// @since 1.1.0
class PayloadMapper {
  /// Log tag for Payload Mapper
  final tag = '${TAG}PayloadMapper';

  /// Get [UserDeletionData] from Json String Payload
  /// [data] - JSON String Payload
  /// [appId] - MoEngage APP-Id
  /// @since 1.1.0
  UserDeletionData deSerializeDeleteUserData(String data, String appId) {
    try {
      final payload = jsonDecode(data) as Map<String, dynamic>;
      Logger.v('$tag deSerializeDeleteUserData(): $data');
      return UserDeletionData(
          accountMeta: accountMetaFromMap(
              payload[keyAccountMeta] as Map<String, dynamic>),
          isSuccess:
              (payload[keyData][keyUserDeletionStatus] ?? false) as bool);
    } catch (ex) {
      Logger.e(' $tag deSerializeDeleteUserData(): Parsing Error', error: ex);
      return UserDeletionData(
          accountMeta: AccountMeta(appId), isSuccess: false);
    }
  }
}
