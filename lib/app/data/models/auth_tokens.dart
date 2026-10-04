class AuthTokens {
  const AuthTokens({required this.access, required this.refresh});

  final String access;
  final String refresh;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    access: json['access'] as String,
    refresh: json['refresh'] as String,
  );

  AuthTokens copyWith({String? access, String? refresh}) => AuthTokens(
    access: access ?? this.access,
    refresh: refresh ?? this.refresh,
  );
}
