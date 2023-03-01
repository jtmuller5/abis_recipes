import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:abis_recipes/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:recase/recase.dart';

class BooksNotifier extends StateNotifier<List<Book>> {
  BooksNotifier() : super(isar.books.buildQuery<Book>().findAllSync());

  Future<void> addBook(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.put(book);
    });
    state = isar.books.buildQuery<Book>().findAllSync();
  }

  Future<void> deleteBook(int bookId) async {
    await isar.writeTxn(() async {
      await isar.books.delete(bookId);
    });
    state = isar.books.buildQuery<Book>().findAllSync();
  }

  Future<void> updateBook(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.put(book);
    });
    state = isar.books.buildQuery<Book>().findAllSync();
  }
}

final booksProvider = StateNotifierProvider<BooksNotifier, List<Book>>((ref) {
  return BooksNotifier();
});

class BookNotifier extends StateNotifier<Book?> {
  BookNotifier(this.bookId) : super(isar.books.getSync(bookId));

  final int bookId;

  void updateBook(Book book) {
    debugPrint('state: ' + state!.title.toString());
    debugPrint('book: ' + book.title.toString());
    debugPrint((state == book).toString());
    state = book;
  }
}

final bookProvider = StateNotifierProvider.family<BookNotifier, Book?, int>((ref, bookId) {
  return BookNotifier(bookId);
});

class BookRecipesNotifier extends StateNotifier<List<Recipe>> {
  BookRecipesNotifier(this.bookId, this.ref)
      : super(isar.recipes.filter().anyOf([bookId], (q, element) => q.bookIdsElementEqualTo(element)).findAllSync()) {
    ref.listen(recipeProvider, (previous, next) {
      state = isar.recipes.filter().anyOf([bookId], (q, element) =>q.bookIdsElementEqualTo(bookId)).findAllSync();
      debugPrint('state: ' + state.toString());
    });
  }

  final int bookId;
  final Ref ref;

  void addRecipe(Recipe recipe) {
    state = [...state, recipe];
  }

  Future<void> removeRecipe(Recipe recipe) async {
    await isar.writeTxn(() async {
      List<int> newBookIds = List.from(recipe.bookIds);
      newBookIds.remove(bookId);
      Recipe updatedRecipe = recipe.copyWith(bookIds: newBookIds);
      await isar.recipes.put(updatedRecipe);
    });
    state = [...state]..remove(recipe);
  }
}

final bookRecipesProvider = StateNotifierProvider.family<BookRecipesNotifier, List<Recipe>, int>((ref, bookId) {
  return BookRecipesNotifier(bookId, ref);
});

final saveToBookProvider = StateProvider<int?>((ref) {
  return null;
});

final checkedBooksProvider = StateProvider<List<int>>((ref) {
  return [];
});

