// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Options _$OptionsFromJson(Map<String, dynamic> json) {
  return Options(
    appStitchKey: json['appStitchKey'] as String,
    clientID: json['clientID'] as String,
  )
    ..id = json['id'] as String
    ..amount = json['amount'] as int
    ..url = json['url'] as String
    ..initialized = json['initialized'] as bool
    ..auth_token = json['auth_token'] as String;
}

Map<String, dynamic> _$OptionsToJson(Options instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'appStitchKey': instance.appStitchKey,
      'url': instance.url,
      'clientID': instance.clientID,
      'initialized': instance.initialized,
      'auth_token': instance.auth_token,
    };
