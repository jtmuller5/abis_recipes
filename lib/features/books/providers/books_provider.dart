import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

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
  BookNotifier(this.bookId, this.ref) : super(isar.books.getSync(bookId)) {
    ref.onDispose(() {
      debugPrint('disposing book notifier');
    });
  }

  final Ref ref;
  final int bookId;

  void updateBook(Book book) {

    debugPrint('state: ' + state!.title.toString());
    debugPrint('book: ' + book.title.toString());
    debugPrint((state == book).toString());
    state = book;
  }
}

final bookProvider = StateNotifierProvider.family<BookNotifier, Book?, int>((ref, bookId) {
  return BookNotifier(bookId, ref);
});

final bookRecipesProvider = StateProvider.family<List<Recipe>, int>((ref, bookId) {
  return isar.recipes.filter().anyOf([bookId], (q, element) => q.bookIdsElementEqualTo(element)).findAllSync();
});

final saveToBookProvider = StateProvider<int?>((ref) {
  return null;
});
