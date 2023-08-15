// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Instruction _$InstructionFromJson(Map<String, dynamic> json) => Instruction(
      text: json['text'] as String?,
      image: json['image'] as String?,
      shortened: json['shortened'] as bool? ?? false,
      shortText: json['shortText'] as String?,
      note: json['note'] == null
          ? null
          : Note.fromJson(json['note'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InstructionToJson(Instruction instance) =>
    <String, dynamic>{
      'text': instance.text,
      'image': instance.image,
      'shortened': instance.shortened,
      'shortText': instance.shortText,
      'note': instance.note?.toJson(),
    };
