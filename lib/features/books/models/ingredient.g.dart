// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      name: json['name'] as String?,
      amount: json['amount'] as String?,
      unit: json['unit'] as String?,
      note: json['note'] == null
          ? null
          : Note.fromJson(json['note'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'unit': instance.unit,
      'note': instance.note?.toJson(),
    };
