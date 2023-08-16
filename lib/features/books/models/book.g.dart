// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Book _$$_BookFromJson(Map<String, dynamic> json) => _$_Book(
      url: json['url'] as String?,
      title: json['title'] as String,
      bookId: json['bookId'] as String,
      description: json['description'] as String?,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      lastRecipe: json['lastRecipe'] == null
          ? null
          : Recipe.fromJson(json['lastRecipe'] as Map<String, dynamic>),
      recipeCount: json['recipeCount'] as int?,
    );

Map<String, dynamic> _$$_BookToJson(_$_Book instance) => <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'bookId': instance.bookId,
      'description': instance.description,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'lastRecipe': instance.lastRecipe?.toJson(),
      'recipeCount': instance.recipeCount,
    };
