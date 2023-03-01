import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class Recipe {

  String? url;

  String? title;

  String? description;

  String? coverImage;

  List<String>? images;

  Id id = Isar.autoIncrement;

  List<Ingredient>? ingredients;

  List<Instruction>? instructions;

  List<int> bookIds = [];

  Recipe({
    this.url,
    this.id=Isar.autoIncrement,
    this.title,
    this.coverImage,
    this.description,
    this.images,
    this.ingredients,
    this.instructions,
    this.bookIds = const [],
  });

  // Copy with
  Recipe copyWith({
    int? id,
    String? url,
    String? title,
    String? description,
    String? coverImage,
    List<String>? images,
    List<Ingredient>? ingredients,
    List<Instruction>? instructions,
    List<int>? bookIds,
  }) {
    return Recipe(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      description: description ?? this.description,
      images: images ?? this.images,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      bookIds: bookIds ?? this.bookIds,
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}
