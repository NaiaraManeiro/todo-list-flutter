
import 'package:encrypt/encrypt.dart';

class EncryptUtil{

  factory EncryptUtil() => _getInstance();

  static EncryptUtil get instance => _getInstance();
  static EncryptUtil? _instance;

  Encrypter _encrypter;
  final iv = IV.fromLength(16);

  EncryptUtil._internal() : _encrypter = _initializeEncrypter();

  static Encrypter _initializeEncrypter() {
    final theKey = Key.fromUtf8("my 32 length key................");
    return Encrypter(AES(theKey, mode: AESMode.cbc, padding: 'PKCS7'));
  }

  static EncryptUtil _getInstance() {
    _instance ??= EncryptUtil._internal();
    return _instance!;
  }

  void reset() {
    _encrypter = _initializeEncrypter();
  }

  String encrypt(String value) {
    if(value.isEmpty) return"";
    return _encrypter.encrypt(value, iv: iv).base64; 
  }

  String decrypt(String value) {
    if(value.isEmpty) return"";
    return _encrypter.decrypt(Encrypted.fromBase64(value), iv: iv);
  }
}