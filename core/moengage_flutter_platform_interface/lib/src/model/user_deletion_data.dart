import 'account_meta.dart';

/// User Deletion Data
/// @author Gowtham KK
/// @since TODO: Update Version
class UserDeletionData{

  /// Constructor for User Deletion Data
  UserDeletionData({required this.accountMeta, required this.isSuccess});

  /// Instance of [AccountMeta]
  /// @since TODO: Update Version
  AccountMeta accountMeta;

  /// True is user is deleted successfully
  /// @since TODO: Update Version
  bool isSuccess;
}
