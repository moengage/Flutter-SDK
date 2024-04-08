import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

class Comparator {
  bool isUserDeletionDataEqual(UserDeletionData data1, UserDeletionData data2) {
    return data1.isSuccess == data2.isSuccess &&
        isAccountMetaEqual(data1.accountMeta, data2.accountMeta);
  }

  bool isAccountMetaEqual(AccountMeta accountMeta1, AccountMeta accountMeta2) {
    return accountMeta1.appId == accountMeta2.appId;
  }
}
