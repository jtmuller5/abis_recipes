import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/providers/books_provider.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/recipe_page.dart';
import 'package:abis_recipes/main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

class RecipeNotifier extends StateNotifier<Recipe?> {
  RecipeNotifier() : super(null);

  static void navigateToRecipe(Recipe recipe, WidgetRef ref, BuildContext context) {
    setRecipe(ref, recipe);
    ref.watch(checkedBooksProvider.notifier).state = recipe.bookIds;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipePage()));
  }

  void createRecipe(String? url) => state = Recipe(
        ingredients: [],
        instructions: [],
        url: url,
      );

  void updateRecipe(Recipe recipe) => state = recipe;

  void clearRecipe() {
    state = null;
  }

  void updateRecipeTitle(String title) => state = state!.copyWith(title: title);

  void updateRecipeDescription(String description) => state = state!.copyWith(description: description);

  void updateRecipeImage(String? image) => state = state!.copyWith(images: [image ?? '']);

  void updateRecipeUrl(String url) => state = state!.copyWith(url: url);

  void updateRecipeIngredients(List<Ingredient> ingredients) => state = state!.copyWith(ingredients: ingredients);

  void updateRecipeInstructions(List<Instruction> instructions) => state = state!.copyWith(instructions: instructions);

  void addInstruction(Instruction instruction) => state = state!.copyWith(instructions: [...state!.instructions!, instruction]);

void updateInstruction(Instruction instruction) {
    final index = state!.instructions!.indexWhere((element) => element.text == instruction.text);
    state = state!.copyWith(instructions: [...state!.instructions!]..[index] = instruction);
  }

  void removeInstruction(Instruction instruction) => state = state!.copyWith(instructions: [...state!.instructions!]..remove(instruction));

  void addIngredient(Ingredient ingredient) {
    // Add if not already in list
    if (!state!.ingredients!.where((element) => element.name == ingredient.name).isNotEmpty) {
      state = state!.copyWith(ingredients: [...state!.ingredients!, ingredient]);
    }
  }

  void removeIngredient(Ingredient ingredient) => state = state!.copyWith(ingredients: [...state!.ingredients!]..remove(ingredient));

  Future<void> deleteRecipes(List<int> ids) async {
    await isar.writeTxn(() async {
      final success = await isar.recipes.deleteAll(ids);
      print('Recipe deleted: $success');
    });

    clearRecipe();
  }
}

final recipeProvider = StateNotifierProvider<RecipeNotifier, Recipe?>((ref) {
  return RecipeNotifier();
});

class RecipesNotifier extends StateNotifier<List<Recipe>> {
  RecipesNotifier(this.ref) : super(isar.recipes.buildQuery<Recipe>().findAllSync()) {
    ref.listen(searchProvider, (previous, next) {
      if (next != null) {
        state = isar.recipes.filter().titleContains(next, caseSensitive: false).findAllSync();
      } else {
        state = isar.recipes.buildQuery<Recipe>().findAllSync();
      }
    });

    ref.listen(recipeProvider, (previous, next) {
      state= isar.recipes.buildQuery<Recipe>().findAllSync();
    });
  }

  final Ref ref;

  Future<void> deleteRecipes(List<int> ids) async {
    await isar.writeTxn(() async {
      final success = await isar.recipes.deleteAll(ids);
      print('Recipe deleted: $success');
    });
    state = isar.recipes.buildQuery<Recipe>().findAllSync();
  }

  void updateRecipes(List<Recipe> recipes) {
    state = recipes;
  }

  void addRecipe(Recipe recipe) {
    state = [...state, recipe];
  }
}

final recipesProvider = StateNotifierProvider<RecipesNotifier, List<Recipe>>((ref) {
  return RecipesNotifier(ref);
});

final searchProvider = StateProvider<String?>((ref) {
  return null;
});
