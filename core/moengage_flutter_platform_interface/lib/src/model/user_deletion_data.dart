import 'account_meta.dart';

/// User Deletion Data
class UserDeletionData{

  /// Constructor for User Deletion Data
  UserDeletionData({required this.accountMeta, required this.isSuccess});

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  /// True is user is deleted successfully
  bool isSuccess;
}
