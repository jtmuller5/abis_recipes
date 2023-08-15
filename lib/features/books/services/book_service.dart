import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:flutter/foundation.dart';

abstract class BookService{

  ValueNotifier<List<String>> checkedBooks = ValueNotifier([]);

  void setCheckedBooks(List<String> val){
    checkedBooks.value = val;
  }

  ValueNotifier<String?> saveToBook = ValueNotifier(null);

  void setSaveToBook(String? val){
    saveToBook.value = val;
  }

  Future<void> createBook(Book book);

  Future<void> updateBook(Book book);

  Future<void> deleteBook(Book book);

  Future<void> addRecipeToBook(Recipe recipe, String bookId);

  Future<void> removeRecipeFromBook(Recipe recipe, String bookId);
}