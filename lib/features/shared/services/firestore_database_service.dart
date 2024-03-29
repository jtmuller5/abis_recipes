import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/shared/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabaseService extends DatabaseService {


  @override
  void createRecipe(Recipe recipe) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('recipes')
        .doc(recipe.recipeId)
        .set(recipe.toJson());
  }

  @override
  void updateRecipe(Recipe recipe) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('recipes')
        .doc(recipe.recipeId)
        .update(recipe.toJson());
  }

  @override
  void deleteRecipe(Recipe recipe) {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipe.recipeId).delete();
  }
}
