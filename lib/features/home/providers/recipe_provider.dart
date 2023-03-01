import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecipeNotifier extends StateNotifier<Recipe?> {
  RecipeNotifier() : super(null);

  void createRecipe() => state = Recipe(
    ingredients: [],
    instructions: [],
  );

  void updateRecipe(Recipe recipe) => state = recipe;

  void clearRecipe() => state = null;

  void updateRecipeTitle(String title) => state = state!.copyWith(title: title);

  void updateRecipeDescription(String description) => state = state!.copyWith(description: description);

  void updateRecipeImage(String? image) => state = state!.copyWith(images: [image ?? '']);

  void updateRecipeUrl(String url) => state = state!.copyWith(url: url);

  void updateRecipeIngredients(List<Ingredient> ingredients) => state = state!.copyWith(ingredients: ingredients);

  void updateRecipeInstructions(List<Instruction> instructions) => state = state!.copyWith(instructions: instructions);

  void addInstruction(Instruction instruction) => state = state!.copyWith(instructions: [...state!.instructions!, instruction]);

  void removeInstruction(Instruction instruction) => state = state!.copyWith(instructions: [...state!.instructions!]..remove(instruction));

  void addIngredient(Ingredient ingredient) {
    // Add if not already in list
    if (!state!.ingredients!.where((element) => element.name == ingredient.name).isNotEmpty) {
      state = state!.copyWith(ingredients: [...state!.ingredients!, ingredient]);
    }
  }

  void removeIngredient(Ingredient ingredient) => state = state!.copyWith(ingredients: [...state!.ingredients!]..remove(ingredient));

  Future<void> deleteRecipe() async {
    if (state?.id == null) return;
    await isar.writeTxn(() async {
      final success = await isar.recipes.delete(state!.id);
      print('Recipe deleted: $success');
    });
  }
}

final recipeProvider = StateNotifierProvider<RecipeNotifier, Recipe?>((ref) {
  return RecipeNotifier();
});
