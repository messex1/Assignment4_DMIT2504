import '../utils/encryption_services.dart';

class PasswordAccount {
  final String site;
  final String username;
  final String password;
  final String? notes;

  PasswordAccount({
    required this.site,
    required this.username,
    required this.password,
    this.notes,
  });

  /// Converts the PasswordAccount object to a map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'site': encryptText(site),
      'username': encryptText(username),
      'password': encryptText(password),
      'notes': notes != null ? encryptText(notes!) : '',
    };
  }

  /// Creates a PasswordAccount object from a map, decrypting values as needed.
  factory PasswordAccount.fromMap(Map<String, dynamic> map) {
    return PasswordAccount(
      site: decryptText(map['site']),
      username: decryptText(map['username']),
      password: decryptText(map['password']),
      notes: map['notes'] != null && map['notes'].isNotEmpty ? decryptText(map['notes']) : null,
    );
  }
}
