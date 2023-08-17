import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecipeViewModelBuilder extends ViewModelBuilder<RecipeViewModel> {
  const RecipeViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => RecipeViewModel();
}

class RecipeViewModel extends ViewModel<RecipeViewModel> {

bool deleting = false;

  Future<void> deleteRecipe(String recipeId) async {
    setState(() {
      deleting = true;
    });
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipeId).delete();

    setState(() {
      deleting = false;
    });
  }

  static void navigateToRecipe(Recipe recipe, BuildContext context) {
    router.push(Uri.parse('/recipe/${recipe.recipeId}').toString());
  }

  Future<void> updateInstruction(Instruction instruction, Recipe? recipe) async {
    if(recipe == null) return;
    try{
      final index = recipe.instructions!.indexWhere((element) => element.text == instruction.text);

      List<Instruction> instructions = [...recipe.instructions!]..[index] = instruction;

      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipe.recipeId).update({
        'instructions': instructions.map((e) => e.toJson()).toList(),
      });
    } catch(e){
      debugPrint('error: ' +e.toString());
    }
  }

  Future<void> updateIngredient(Ingredient ingredient, Recipe recipe) async {
    try{
      final index = recipe.ingredients!.indexWhere((element) => element.name == ingredient.name);

      List<Ingredient> ingredients = [...recipe.ingredients!]..[index] = ingredient;

      debugPrint('ingredients: ' + ingredients.toString());

      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipe.recipeId).update({
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
      });
    } catch(e){
      debugPrint('error: ' +e.toString());
    }
  }


  static RecipeViewModel of_(BuildContext context) => getModel<RecipeViewModel>(context);
}