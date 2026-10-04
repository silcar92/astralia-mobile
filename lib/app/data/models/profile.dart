/// Perfil propio. Por ahora solo lo que la base necesita; se amplía con cada pantalla (el API devuelve más).
class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.emailVerified,
    required this.language,
    this.toursSeen = const [],
  });

  final int id;
  final String name;
  final bool emailVerified;
  final String language;
  final List<String> toursSeen;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] as int,
    name: (json['name'] as String?) ?? '',
    emailVerified: (json['email_verified'] as bool?) ?? false,
    language: (json['language'] as String?) ?? 'es',
    toursSeen: ((json['tours_seen'] as List?) ?? const []).cast<String>(),
  );
}
