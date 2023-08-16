// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Recipe _$$_RecipeFromJson(Map<String, dynamic> json) => _$_Recipe(
      recipeId: json['recipeId'] as String,
      url: json['url'] as String?,
      title: json['title'] as String?,
      coverImage: json['coverImage'] as String?,
      description: json['description'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>?)
          ?.map((e) => Instruction.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookIds:
          (json['bookIds'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: getDateTimeFromTimestamp(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$$_RecipeToJson(_$_Recipe instance) => <String, dynamic>{
      'recipeId': instance.recipeId,
      'url': instance.url,
      'title': instance.title,
      'coverImage': instance.coverImage,
      'description': instance.description,
      'images': instance.images,
      'ingredients': instance.ingredients?.map((e) => e.toJson()).toList(),
      'instructions': instance.instructions?.map((e) => e.toJson()).toList(),
      'bookIds': instance.bookIds,
      'createdAt': getTimestampFromDateTime(instance.createdAt),
    };
