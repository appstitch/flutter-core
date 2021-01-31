library core;

import 'package:appstitch_core/Config.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

class Core {
  Future<dynamic> makeRequst(String endpoint, Object payload) async {
    final random = new Random();
    int randomNumber = random.nextInt(10000);
    Config config = Config();

    final url = config.url + endpoint;

    final key = utf8.encode(config.appStitchKey);
    final aesKey = Key.fromUtf8(config.appStitchKey);
    final encrypter = Encrypter(AES(aesKey));

    final pl = json.encode(payload);
    final iv = IV.fromLength(16);
    var body = {
      "payload": encrypter.encrypt(json.encode(payload), iv: iv),
      "auth_token": null
    };

    if (config.auth_token != null) {
      body["auth_token"] = encrypter.encrypt(config.auth_token, iv: iv);
    }

    final nonce = randomNumber.toString();

    var headers = {
      "clientID": config.clientID,
      "authentication": "test",
      "nonce": nonce
    };

    var response = http
        .post(url, headers: headers, body: body)
        .then((result) => json.decode(result.body));
    return response;
  }
}
