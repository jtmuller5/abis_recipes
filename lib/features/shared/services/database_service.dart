import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';

abstract class DatabaseService{
  void createBook(Book book);

  void updateBook(Book book);

  void deleteBook(Book book);

  void createRecipe(Recipe recipe);

  void updateRecipe(Recipe recipe);

  void deleteRecipe(Recipe recipe);
}