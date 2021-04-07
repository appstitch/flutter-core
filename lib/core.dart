library appstitch_core;

import 'options.dart';
import 'constants.dart' as constants;
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:math';

import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:tuple/tuple.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

export 'options.dart';

class Core<T> {
  Core._privateConstructor();

  static final Core _instance = Core._privateConstructor();

  factory Core() {
    return _instance as Core<T>;
  }

  Options _config = Options();

  Options options() {
    return _config;
  }

  initialize(Options options) {
    _config = options;
    if (options.url == null) {
      _config.url = constants.url;
    }

    _config.initialized = true;
  }

  setAuthToken(String token) {
    _config.auth_token = token;
  }

  Future<Options> clearAuthToken() async {
    _config.auth_token = null;

    final payload = {
      "token": _config.auth_token,
    };
    final result = await makeRequest("admin/clearToken", payload).then((value) {
      _config.auth_token = null;
      return _config;
    }).catchError((error) {
      return _config;
    });

    return result;
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  Uint8List genRandomWithNonZero(int seedLength) {
    final random = Random.secure();
    const int randomMax = 245;
    final Uint8List uint8list = Uint8List(seedLength);
    for (int i = 0; i < seedLength; i++) {
      uint8list[i] = random.nextInt(randomMax) + 1;
    }
    return uint8list;
  }

  Tuple2<Uint8List, Uint8List> deriveKeyAndIV(
      String passphrase, Uint8List salt) {
    var password = createUint8ListFromString(passphrase);
    Uint8List concatenatedHashes = Uint8List(0);
    Uint8List currentHash = Uint8List(0);
    bool enoughBytesForKey = false;
    Uint8List preHash = Uint8List(0);

    while (!enoughBytesForKey) {
      if (currentHash.length > 0)
        preHash = Uint8List.fromList(currentHash + password + salt);
      else
        preHash = Uint8List.fromList(password + salt);

      currentHash = md5.convert(preHash).bytes as Uint8List;
      concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
      if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
    }

    var keyBtyes = concatenatedHashes.sublist(0, 32);
    var ivBtyes = concatenatedHashes.sublist(32, 48);
    return new Tuple2(keyBtyes, ivBtyes);
  }

  String encryptAES(String plainText, String passphrase) {
    try {
      final salt = genRandomWithNonZero(8);
      var keyndIV = deriveKeyAndIV(passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      Uint8List encryptedBytesWithSalt = Uint8List.fromList(
          createUint8ListFromString("Salted__") + salt + encrypted.bytes);
      return base64.encode(encryptedBytesWithSalt);
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>?> makeRequest(
      String endpoint, Object payload) async {
    final random = new Random();
    int randomNumber = random.nextInt(100000) * random.nextInt(6);

    // final url = _config.url! + endpoint;

    Map<String, String> body = {
      "payload": encryptAES(json.encode(payload), _config.appStitchKey!),
    };

    if (_config.auth_token != null) {
      body["auth_token"] =
          encryptAES(_config.auth_token!, _config.appStitchKey!);
    }
    final nonce = randomNumber.toString();

    Map<String, String> headers = {
      "clientid": _config.clientID!,
      "xasnonce": nonce,
      "content-type": "application/json"
    };

    try {
      var response = await http
          .post(Uri.https(_config.url!, endpoint),
              headers: headers, body: jsonEncode(body))
          .then((result) {
        return jsonDecode(result.body) as Map<String, dynamic>;
      });

      return response;
    } catch (err) {
      print(err);
      return jsonDecode(err.toString()) as Map<String, dynamic>?;
    }
  }
}
