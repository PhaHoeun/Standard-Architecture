class AuthUser {
  final int id;
  final String name;
  final String email;
  final String username;
  final String avatarUrl;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.avatarUrl,
  });
}
