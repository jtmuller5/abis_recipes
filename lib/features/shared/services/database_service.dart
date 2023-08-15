import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';

abstract class DatabaseService{

  void createRecipe(Recipe recipe);

  void updateRecipe(Recipe recipe);

  void deleteRecipe(Recipe recipe);
}