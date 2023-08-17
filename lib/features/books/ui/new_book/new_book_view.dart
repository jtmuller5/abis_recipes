import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/shared/ui/pastry_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'new_book_view_model.dart';

class NewBookView extends StatelessWidget {
  const NewBookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewBookViewModelBuilder(
      builder: (context, model) {
        return Scaffold(
            appBar: AppBar(
              title: Text('New Recipe Book'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: model.bookTitleController,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                ),
                gap32,
                Center(
                  child: Text('Select a Cover', style: Theme.of(context).textTheme.headline6),
                ),
                Expanded(
                  child: PageView(
                    controller: model.pageController,
                    scrollDirection: Axis.horizontal,
                    children: Pastry.values
                        .map((e) => PastryIcon(
                              pastry: e,
                              sideLength: 200,
                            ))
                        .toList(),
                  ),
                ),
                gap64,
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                bookService.createBook(Book(
                  bookId: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').doc().id,
                  title: model.bookTitleController.text,
                  dateCreated: DateTime.now(),
                  description: null,
                  url: null,
                  lastRecipe: null,
                  recipeCount: 0,
                  pastry: Pastry.values[model.pageController.page!.toInt()],
                ));

                router.pop();
              },
              child: Icon(Icons.check),
            ));
      },
    );
  }
}
