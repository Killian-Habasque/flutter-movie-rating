class RequestTokenModel {
  final String requestToken;
  final bool success;
  final String expiresAt;

  RequestTokenModel({
    required this.requestToken,
    required this.success,
    required this.expiresAt,
  });

  factory RequestTokenModel.fromJson(Map<String, dynamic> json) {
    return RequestTokenModel(
      requestToken: json['request_token'],
      success: json['success'],
      expiresAt: json['expires_at'],
    );
  }
}

class SessionModel {
  final String sessionId;
  final bool success;

  SessionModel({
    required this.sessionId,
    required this.success,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['session_id'],
      success: json['success'],
    );
  }
}