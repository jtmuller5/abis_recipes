import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/services/book_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookService)
class FirestoreBookService extends BookService {
  @override
  Future<void> createBook(Book book) async {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').doc(book.bookId.toString()).set(book.toJson());
  }

  @override
  Future<void> updateBook(Book book) async{
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').doc(book.bookId).update(book.toJson());
  }

  @override
  Future<void> deleteBook(Book book)async {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').doc(book.bookId).delete();
  }

  @override
  Future<void> addRecipeToBook(Recipe recipe, String bookId)async {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipe.recipeId).update({
      'bookIds': FieldValue.arrayUnion([bookId])
    });

    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').doc(bookId).update({
      'recipeCount': FieldValue.increment(1)
    });
  }

  @override
  Future<void> removeRecipeFromBook(Recipe recipe, String bookId) async{
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(recipe.recipeId).update({
      'bookIds': FieldValue.arrayRemove([bookId])
    });

    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').doc(bookId).update({
      'recipeCount': FieldValue.increment(-1)
    });
  }
}
