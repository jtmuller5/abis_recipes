import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddRecipeToBookViewModelBuilder extends ViewModelBuilder<AddRecipeToBookViewModel> {
  const AddRecipeToBookViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => AddRecipeToBookViewModel();
}

class AddRecipeToBookViewModel extends ViewModel<AddRecipeToBookViewModel> {
  void addCheckedBook(String bookId) {
    setState(() {
      bookService.setCheckedBooks([...bookService.checkedBooks.value, bookId]);
    });
  }

  void removeCheckedBook(String bookId) {
    setState(() {
      bookService.setCheckedBooks(bookService.checkedBooks.value.where((element) => element != bookId).toList());
    });
  }

  void updateRecipe(Recipe recipe) {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipe.recipeId).update(recipe.toJson());
  }

  static AddRecipeToBookViewModel of_(BuildContext context) => getModel<AddRecipeToBookViewModel>(context);
}
