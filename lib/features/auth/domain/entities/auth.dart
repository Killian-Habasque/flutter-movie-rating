class RequestToken {
  final String requestToken;
  final bool success;
  final String expiresAt;

  RequestToken({
    required this.requestToken,
    required this.success,
    required this.expiresAt,
  });
}

class Session {
  final String sessionId;
  final bool success;

  Session({
    required this.sessionId,
    required this.success,
  });
} 