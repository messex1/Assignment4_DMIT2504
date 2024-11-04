import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'dart:convert';

final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // Use a secure key
final _iv = encrypt.IV.fromLength(16); // Initialization vector with 16-byte length

/// Encrypts plain text input.
String encryptText(String input) {
  final encrypter = encrypt.Encrypter(encrypt.AES(_key));
  final encrypted = encrypter.encrypt(input, iv: _iv);
  return encrypted.base64;
}

/// Decrypts the encrypted text input.
String decryptText(String encryptedInput) {
  final encrypter = encrypt.Encrypter(encrypt.AES(_key));
  final decrypted = encrypter.decrypt64(encryptedInput, iv: _iv);
  return decrypted;
}

/// Hashes text using SHA-256.
String hashText(String text) {
  return sha256.convert(utf8.encode(text)).toString();
}
