import 'dart:convert';
import 'package:crypto/crypto.dart';

String encryptPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}

// void main() {
//   String testPassword = "afif";
//   print('Original: $testPassword');
//   print('Encrypted: ${encryptPassword(testPassword)}');
// }
