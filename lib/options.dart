import 'package:json_annotation/json_annotation.dart';
part 'options.g.dart';

@JsonSerializable(explicitToJson: true)
class Options {
  Options({this.appStitchKey, this.clientID});

  String id;
  int amount;
  String appStitchKey;
  String url;
  String clientID;
  bool initialized;
  String auth_token;

  factory Options.fromJson(Map<String, dynamic> json) =>
      _$OptionsFromJson(json);
  Map<String, dynamic> toJson() => _$OptionsToJson(this);
}
