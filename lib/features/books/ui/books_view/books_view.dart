import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/ui/books_view/books_view_model.dart';
import 'package:abis_recipes/features/shared/ui/pastry_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BooksView extends StatelessWidget {
  const BooksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BooksViewModelBuilder(
      builder: (context, model) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('My Recipe Books'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 16),
                    child: PastryIcon(
                      pastry: Pastry.eclair,
                      asset: 'assets/book.png',
                    ),
                  )
                ],
              ),
              StreamBuilder<List<Book>>(
                  stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').snapshots().map((event) {
                    return event.docs.map((e) => Book.fromJson(e.data())).toList();
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.isNotEmpty) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              Book book = snapshot.data![index];
                              return ListTile(
                                leading: PastryIcon(pastry: book.pastry),
                                title: Text(book.title),
                                subtitle: FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth.instance.currentUser?.uid)
                                        .collection('recipes')
                                        .where('bookIds', arrayContains: book.bookId)
                                        .count()
                                        .get(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Align(
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              height: 16,
                                              width: 50,
                                              child: ColoredBox(
                                                color: Colors.grey.shade200,
                                              ),
                                            ).animate(onPlay: (controller) => controller.repeat()).shimmer(),
                                          );
                                        default:
                                          if (snapshot.hasError) {
                                            return Text('Error loading recipes');
                                          } else {
                                            return Text('${snapshot.data!.count} recipes');
                                          }
                                      }
                                    }),
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Add a book to get started', style: Theme.of(context).textTheme.titleLarge),
                              PastryIcon(
                                pastry: Pastry.eclair,
                                asset: 'assets/book.png',
                                sideLength: 200,
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              AggregateQuerySnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('books').count().get();

              if (snap.count > 3 && !subscriptionService.premium.value) {
                await subscriptionService.showPremiumPopup();
              } else {
                router.push('/new-book');
              }
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
