import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/ui/books_view/books_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BooksView extends StatelessWidget {
  const BooksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BooksViewModelBuilder(
      builder: (context, model) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(title: Text('My Recipe Books')),
              StreamBuilder<List<Book>>(
                  stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').snapshots().map((event) {
                    return event.docs.map((e) => Book.fromJson(e.data())).toList();
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.isNotEmpty) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              Book book = snapshot.data![index];
                              return ListTile(
                                leading: Hero(
                                  tag: 'recipe-${book.lastRecipe?.recipeId ?? book.title}',
                                  child: SizedBox(
                                      height: 64,
                                      width: 64,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: book.lastRecipe?.images?.firstOrNull != null
                                            ? FadeInImage(
                                          placeholder: AssetImage('assets/transparent.png'),
                                          image: NetworkImage(
                                            book.lastRecipe?.images?.first ?? '',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                            : ColoredBox(color: Theme.of(context).colorScheme.secondary, child: Icon(Icons.book)),
                                      )),
                                ),
                                title: Text(book.title),
                                subtitle: Text('${book.recipeCount ?? 0} recipes'),
                                onTap: () {
                                  router.push('/book/${book.bookId}');
                                },
                              );
                            },
                            childCount: snapshot.data!.length,
                          ),
                        );
                      } else {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.book,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                Text(
                                  'No Recipe Books',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  'Create a new recipe book to get started',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      return SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return DecoratedBox(
                    decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'New Recipe Book',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: model.bookTitleController,
                              decoration: InputDecoration(hintText: 'Name'),
                            ),
                          ),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              router.pop();
                                            },
                                            child: Text('Cancel')),
                                        gap16,
                                        OutlinedButton(
                                            onPressed: () async {
                                              bookService.createBook(Book(
                                                bookId: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').doc().id,
                                                title: model.bookTitleController.text,
                                                dateCreated: DateTime.now(),
                                                description: null,
                                                url: null,
                                                lastRecipe: null,
                                                recipeCount: 0,
                                              ));

                                              router.pop();
                                            },
                                            child: Text('Save'))
                                      ],
                                    ),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            label: Text('New'),
            icon: Icon(Icons.add),
          ),
        );
      },
    );
  }
}