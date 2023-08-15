import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/note.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CurrentRecipeService {
  ValueNotifier<Recipe?> recipe = ValueNotifier(null);

  void setRecipe(Recipe val) {
    recipe.value = val;
  }

  static List<Note> getAllNotes(Recipe recipe) {
    List<Note> notes = [];

    recipe.ingredients?.forEach((ingredient) {
      if (ingredient.note != null) {
        notes.add(ingredient.note!);
      }
    });

    recipe.instructions?.forEach((instruction) {
      if (instruction.note != null) {
        notes.add(instruction.note!);
      }
    });

    return notes;
  }

  static List<Ingredient> getIngredientsWithNotes(Recipe recipe) {
    List<Ingredient> ingredients = [];

    recipe.ingredients?.forEach((ingredient) {
      if (ingredient.note != null) {
        ingredients.add(ingredient);
      }
    });

    return ingredients;
  }

  static List<Instruction> getInstructionsWithNotes(Recipe recipe) {
    List<Instruction> instructions = [];

    recipe.instructions?.forEach((instruction) {
      if (instruction.note != null) {
        instructions.add(instruction);
      }
    });

    return instructions;
  }

  void createRecipe(String? url) {
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc();
    setRecipe(Recipe(
      recipeId: ref.id,
      ingredients: [],
      instructions: [],
      url: url,
      bookIds: [],
      coverImage: null,
      description: null,
      images: [],
      title: null,
    ));
  }

  void updateRecipe(Recipe recipe) {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipe.recipeId).update(recipe.toJson());
    setRecipe(recipe);
  }

  void clearRecipe() {
    recipe.value = null;
  }

  void updateRecipeTitle(String title) => setRecipe(recipe.value!.copyWith(title: title));

  void updateRecipeDescription(String description) => setRecipe(recipe.value!.copyWith(description: description));

  void updateRecipeImage(String? image) => setRecipe(recipe.value!.copyWith(images: [image ?? '']));

  void updateRecipeUrl(String url) => setRecipe(recipe.value!.copyWith(url: url));

  void updateRecipeIngredients(List<Ingredient> ingredients) => setRecipe(recipe.value!.copyWith(ingredients: ingredients));

  void updateRecipeInstructions(List<Instruction> instructions) => setRecipe(recipe.value!.copyWith(instructions: instructions));

  void addInstruction(Instruction instruction) => setRecipe(recipe.value!.copyWith(instructions: [...recipe.value!.instructions!, instruction]));

  Future<void> updateInstruction(Instruction instruction) async {
    final index = recipe.value!.instructions!.indexWhere((element) => element.text == instruction.text);

    Recipe newState = recipe.value!.copyWith(instructions: [...recipe.value!.instructions!]..[index] = instruction);

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipe.value!.recipeId).update({
      'instructions': recipe.value!.instructions!.map((e) => e.toJson()).toList(),
    });

    setRecipe(newState);
  }

  Future<void> updateIngredient(Ingredient ingredient) async {
    final index = recipe.value!.ingredients!.indexWhere((element) => element.name == ingredient.name);

    Recipe newState = recipe.value!.copyWith(ingredients: [...recipe.value!.ingredients!]..[index] = ingredient);

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipe.value!.recipeId).update({
      'ingredients': recipe.value!.ingredients!.map((e) => e.toJson()).toList(),
    });

    setRecipe(newState);
  }

  void removeInstruction(Instruction instruction) => setRecipe(recipe.value!.copyWith(instructions: [...recipe.value!.instructions!]..remove(instruction)));

  void addIngredient(Ingredient ingredient) {
    // Add if not already in list
    if (!recipe.value!.ingredients!.where((element) => element.name == ingredient.name).isNotEmpty) {
      setRecipe(recipe.value!.copyWith(ingredients: [...recipe.value!.ingredients!, ingredient]));
    }
  }

  void removeIngredient(Ingredient ingredient) => setRecipe(recipe.value!.copyWith(ingredients: [...recipe.value!.ingredients!]..remove(ingredient)));

  Future<void> deleteRecipe(String recipeId) async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipeId).delete();

    clearRecipe();
  }
}
