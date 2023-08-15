import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';

part 'recipe.g.dart';

@freezed
class Recipe with _$Recipe{

  const factory Recipe({
    required String recipeId,
    required String? url,
    required String? title,
    required String? coverImage,
    required String? description,
    required List<String>? images,
    required List<Ingredient>? ingredients,
    required List<Instruction>? instructions,
    required List<String> bookIds,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, Object?> json) => _$RecipeFromJson(json);
}
