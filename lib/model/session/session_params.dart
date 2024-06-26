// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SessionParams {
  final String sessionId;
  final String accountId;

  SessionParams({
    required this.sessionId,
    required this.accountId,
  });

  SessionParams copyWith({
    String? sessionId,
    String? accountId,
  }) {
    return SessionParams(
      sessionId: sessionId ?? this.sessionId,
      accountId: accountId ?? this.accountId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sessionId': sessionId,
      'accountId': accountId,
    };
  }

  factory SessionParams.fromMap(Map<String, dynamic> map) {
    return SessionParams(
      sessionId: map['sessionId'] as String,
      accountId: map['accountId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionParams.fromJson(String source) => SessionParams.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SessionParams(sessionId: $sessionId, accountId: $accountId)';

  @override
  bool operator ==(covariant SessionParams other) {
    if (identical(this, other)) return true;
  
    return 
      other.sessionId == sessionId &&
      other.accountId == accountId;
  }

  @override
  int get hashCode => sessionId.hashCode ^ accountId.hashCode;
}
