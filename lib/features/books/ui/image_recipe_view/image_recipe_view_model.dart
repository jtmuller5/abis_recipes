import 'dart:convert';

import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageRecipeViewModelBuilder extends ViewModelBuilder<ImageRecipeViewModel> {
  const ImageRecipeViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => ImageRecipeViewModel();
}

class ImageRecipeViewModel extends ViewModel<ImageRecipeViewModel> {

  ValueNotifier<bool> savingRecipe = ValueNotifier(false);

  void setSavingRecipe(bool val){
    savingRecipe.value = val;
  }

  Future<String?> loadImage(String ref) async {
    final gsReference = FirebaseStorage.instance.refFromURL(ref);

    return gsReference.getDownloadURL();
  }

  Recipe? getRecipeFromOutput(String output) {
    String formatted = output.replaceAll('```json', '').replaceAll('```', '').trim();

    debugPrint('formatted: ' + formatted.toString());

    Map<String, dynamic> json = jsonDecode(formatted);

    Recipe recipe = Recipe(
      createdAt: DateTime.now(),
      images: [],
      description: '',
      coverImage: null,
      bookIds: [],
      url: null,
      ingredients: json['ingredients'].map<Ingredient>((e) => Ingredient(name: replaceWithFractions(e.replaceAll('&#x2F;','/').trim()))).toList(),
      instructions: json['instructions'].map<Instruction>((e) => Instruction(text: e.replaceAll('&#x2F;','/').trim())).toList(),
      recipeId: 'test',
      title: json['name'],
    );

    return recipe;
  }

  String replaceWithFractions(String input){
    return input.replaceAll('14', '¼').replaceAll('12', '½').replaceAll('34', '¾').replaceAll('18', '⅛').replaceAll('38', '⅜').replaceAll('58', '⅝').replaceAll('78', '⅞')
    .replaceAll('%fl', '½fl')
    .replaceAll('%oz', '½oz')
        .replaceAll('%2oz', '½oz')
        .replaceAll('%20z', '½oz');
  }

  Future<void> saveImageRecipe(Recipe recipe) async {
    try{
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc();

      Recipe newRecipe = recipe.copyWith(recipeId: ref.id);

      await ref.set(newRecipe.toJson());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe saved!')));
      setSavingRecipe(false);
      router.pushReplacement('/recipe/${ref.id}');
    } catch(e){
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving recipe')));
      setSavingRecipe(false);
    }
  }

  static ImageRecipeViewModel of_(BuildContext context) => getModel<ImageRecipeViewModel>(context);
}
