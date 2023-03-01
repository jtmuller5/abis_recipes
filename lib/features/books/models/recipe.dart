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

  List<String>? images;

  Id id = Isar.autoIncrement;

  List<Ingredient>? ingredients;

  List<Instruction>? instructions;

  List<int> bookIds = [];

  Recipe({
    this.url,
    this.title,
    this.description,
    this.images,
    this.ingredients,
    this.instructions,
    this.bookIds = const [],
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}
