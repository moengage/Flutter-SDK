import 'account_meta.dart';

/// User Deletion Data
/// @author Gowtham KK
/// @since 1.1.0
class UserDeletionData {
  /// Constructor for User Deletion Data
  UserDeletionData({required this.accountMeta, required this.isSuccess});

  /// Instance of [AccountMeta]
  /// @since 1.1.0
  AccountMeta accountMeta;

  /// True if the user is deleted successfully, else false.
  /// @since 1.1.0
  bool isSuccess;
}
