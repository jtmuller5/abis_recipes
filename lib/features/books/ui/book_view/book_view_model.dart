import 'package:abis_recipes/features/books/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookViewModelBuilder extends ViewModelBuilder<BookViewModel> {
  const BookViewModelBuilder(
    this.bookId, {
    super.key,
    required super.builder,
  });

  final String bookId;

  @override
  State<StatefulWidget> createState() => BookViewModel(bookId);
}

class BookViewModel extends ViewModel<BookViewModel> {
  final String bookId;

  BookViewModel(this.bookId);

  static BookViewModel of_(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<ViewModelProvider<ViewModel<BookViewModel>>>()!.state) as BookViewModel;

  Book? book;

  @override
  void initState() {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').doc(bookId).get().then((value) {
      book = Book.fromJson(value.data()!);
      setState(() {});
    });
    super.initState();
  }
}
