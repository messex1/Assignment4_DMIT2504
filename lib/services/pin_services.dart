import 'package:shared_preferences/shared_preferences.dart';
import '../utils/encryption_services.dart'; // Updated import path

const String _pinKey = 'pin';

/// Hashes the provided PIN.
/// Returns the hashed PIN as a string.
String hashPin(String pin) {
  return hashText(pin); // Uses the hash function from `encryption_services.dart`
}

/// Stores the hashed PIN in local storage.
Future<void> storePin(String pin) async {
  final prefs = await SharedPreferences.getInstance();
  final hashedPin = hashPin(pin);
  await prefs.setString(_pinKey, hashedPin);
}

/// Checks if the provided PIN matches the stored hashed PIN.
/// Returns true if it matches, false otherwise.
Future<bool> checkPin(String pin) async {
  final prefs = await SharedPreferences.getInstance();
  final storedHashedPin = prefs.getString(_pinKey);
  if (storedHashedPin == null) return false;
  return hashPin(pin) == storedHashedPin;
}

/// Checks if a PIN has already been stored.
/// Returns true if a hashed PIN exists in local storage, false otherwise.
Future<bool> pinStored() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(_pinKey);
}
