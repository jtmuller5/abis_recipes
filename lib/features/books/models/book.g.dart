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
      pastry: $enumDecode(_$PastryEnumMap, json['pastry']),
      dateCreated: getDateTimeFromTimestamp(json['dateCreated'] as Timestamp?),
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
      'pastry': _$PastryEnumMap[instance.pastry]!,
      'dateCreated': getTimestampFromDateTime(instance.dateCreated),
      'lastRecipe': instance.lastRecipe?.toJson(),
      'recipeCount': instance.recipeCount,
    };

const _$PastryEnumMap = {
  Pastry.cupCake: 'cupCake',
  Pastry.chocolateCake: 'chocolateCake',
  Pastry.cheesecake: 'cheesecake',
  Pastry.cookies: 'cookies',
  Pastry.croissant: 'croissant',
  Pastry.eclair: 'eclair',
  Pastry.danish: 'danish',
  Pastry.macarons: 'macarons',
  Pastry.milkBread: 'milkBread',
  Pastry.donuts: 'donuts',
  Pastry.brioche: 'brioche',
  Pastry.mousse: 'mousse',
  Pastry.tart: 'tart',
};
