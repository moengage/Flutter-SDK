// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

/// MoEngage AppId / Workspace ID
const String WORKSPACE_ID = '<YOUR_WORKSPACE_ID>';

/// POST endpoint that issues a JWT for the given user. Replace with your own
/// backend endpoint that generates a JWT signed as per the MoEngage JWT spec.
const String IAM_JWT_TOKEN_URL = '<YOUR_JWT_ISSUING_ENDPOINT>';

/// Payload key for user id in IAM request body.
const String IAM_PAYLOAD_UID_KEY = 'uid';
