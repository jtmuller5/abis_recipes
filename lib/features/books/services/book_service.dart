import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';

abstract class BookService{

  Future<void> createBook(Book book);

  Future<void> updateBook(Book book);

  Future<void> deleteBook(Book book);

  Future<void> addRecipeToBook(Recipe recipe, String bookId);

  Future<void> removeRecipeFromBook(Recipe recipe, String bookId);
}