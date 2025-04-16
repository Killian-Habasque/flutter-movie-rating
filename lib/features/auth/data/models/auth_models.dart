 class RequestToken {
  final String requestToken;
  final bool success;
  final String expiresAt;

  RequestToken({
    required this.requestToken,
    required this.success,
    required this.expiresAt,
  });

  factory RequestToken.fromJson(Map<String, dynamic> json) {
    return RequestToken(
      requestToken: json['request_token'],
      success: json['success'],
      expiresAt: json['expires_at'],
    );
  }
}

class Session {
  final String sessionId;
  final bool success;

  Session({
    required this.sessionId,
    required this.success,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['session_id'],
      success: json['success'],
    );
  }
}