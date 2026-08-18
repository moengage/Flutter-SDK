import 'authentication_data.dart';
import 'authentication_type.dart';

/// Request payload for [MoEngageFlutter.passAuthenticationDetails].
class AuthenticationDetailsRequest {
  /// [AuthenticationDetailsRequest] Constructor
  AuthenticationDetailsRequest({
    required this.authenticationType,
    required this.data,
  });

  /// Authentication scheme used
  AuthenticationType authenticationType;

  /// Scheme specific authentication payload, instance of [AuthenticationDetails]
  AuthenticationDetails data;
}
