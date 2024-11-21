import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

String encryptPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}

// Add main function for CLI testing
void main() {
  while (true) {
    stdout.write('Masukkan password (ketik "exit" untuk keluar): ');
    final input = stdin.readLineSync();

    if (input == null || input.toLowerCase() == 'exit') {
      print('Program selesai.');
      break;
    }

    final encrypted = encryptPassword(input);
    print('Password asli  : $input');
    print('Hasil encrypt : $encrypted');
    print('Panjang hash  : ${encrypted.length} karakter\n');
  }
}
