// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Options _$OptionsFromJson(Map<String, dynamic> json) {
  return Options(
    appStitchKey: json['appStitchKey'] as String?,
    clientID: json['clientID'] as String?,
    url: json['url'] as String?,
    auth_token: json['auth_token'] as String?,
  )..initialized = json['initialized'] as bool?;
}

Map<String, dynamic> _$OptionsToJson(Options instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('appStitchKey', instance.appStitchKey);
  writeNotNull('url', instance.url);
  writeNotNull('clientID', instance.clientID);
  writeNotNull('initialized', instance.initialized);
  writeNotNull('auth_token', instance.auth_token);
  return val;
}
