import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/main.dart';
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

  Future<void> deleteBook(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.delete(book.id);
    });
    state = isar.books.buildQuery<Book>().findAllSync();
  }
}

final booksProvider = StateNotifierProvider<BooksNotifier, List<Book>>((ref) {
  return BooksNotifier();
});

final bookProvider = StateProvider.family<Book?, int>((ref, bookId) {
  return isar.books.getSync(bookId);
});

final bookRecipesProvider = StateProvider.family<List<Recipe>, int>((ref, bookId) {
  return isar.recipes.filter().anyOf([bookId], (q, element) => q.bookIdsElementEqualTo(element)).findAllSync();
});

final saveToBookProvider = StateProvider<int?>((ref) {
  return null;
});
