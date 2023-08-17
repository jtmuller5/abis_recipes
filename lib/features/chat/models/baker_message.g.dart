// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baker_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BakerMessage _$$_BakerMessageFromJson(Map<String, dynamic> json) =>
    _$_BakerMessage(
      prompt: json['prompt'] as String?,
      response: json['response'] as String?,
      createdAt: getDateTimeFromTimestamp(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$$_BakerMessageToJson(_$_BakerMessage instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
      'response': instance.response,
      'createdAt': getTimestampFromDateTime(instance.createdAt),
    };
