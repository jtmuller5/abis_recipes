import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/recipe_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:collection/collection.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'book_view_model.dart';

class BookView extends StatelessWidget with GetItMixin {
  BookView({Key? key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context) {
    return BookViewModelBuilder(
      bookId,
      builder: (context, model) {
        Book? book = model.book;

        return Scaffold(
            body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(book?.title ?? 'No title'),
              actions: [
                Builder(builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () async {
                      Rect? rect;
                      RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                      final renderObject = context.findRenderObject();
                      final translation = renderObject?.getTransformTo(null).getTranslation();
                      if (translation != null && renderObject?.paintBounds != null) {
                        final offset = Offset(translation.x, translation.y);
                        rect = renderObject!.paintBounds.shift(offset);
                      }
                      if (rect != null) {
                        var value = await showMenu<String>(
                          context: context,
                          position: RelativeRect.fromRect(
                            rect,
                            Offset.zero & overlay.size,
                          ),
                          items: [
                            const PopupMenuItem(value: 'rename', child: Text('Rename Book')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete Book')),
                          ],
                        );
                        if (value != null) {
                          debugPrint(value);
                          if (value == 'rename') {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController bookTitleController = TextEditingController(text: book?.title);
                                return AlertDialog(
                                  title: Text('Rename Book'),
                                  content: TextField(
                                    controller: bookTitleController,
                                    decoration: InputDecoration(
                                      labelText: 'Book Title',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Book? updatedBook = book;
                                        if (updatedBook == null) return;

                                        debugPrint('updatedBook: ' + updatedBook.title.toString());
                                        debugPrint('bookId: ' + bookId.toString());
                                        debugPrint('updatedBook.id: ' + updatedBook.bookId);

                                        Book newBook = Book(
                                          bookId: updatedBook.bookId,
                                          title: bookTitleController.text,
                                          dateCreated: updatedBook.dateCreated,
                                          url: updatedBook.url,
                                          description: '',
                                          lastRecipe: updatedBook.lastRecipe,
                                          recipeCount: updatedBook.recipeCount,
                                        );
                                        bookService.updateBook(newBook);

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book renamed')));
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Rename'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (value == 'delete') {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete Book'),
                                  content: Text('Are you sure you want to delete this book?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        bookService.deleteBook(book!);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book deleted')));
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                  );
                })
              ],
            ),
            StreamBuilder<List<Recipe>>(
                stream:
                    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').where('bookIds', arrayContains: bookId).snapshots().map((event) {
                  return event.docs.map((e) => Recipe.fromJson(e.data())).toList();
                }),
                builder: (context, snapshot) {
                  if ((snapshot.data ?? []).length > 0) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          Recipe recipe = snapshot.data![index];
                          return Builder(builder: (context) {
                            return ListTile(
                              leading: Hero(
                                tag: 'recipe-${recipe.recipeId}',
                                child: SizedBox(
                                    height: 64,
                                    width: 64,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: recipe.images?.firstOrNull != null
                                          ? Image.network(
                                              recipe.images?.first ?? '',
                                              fit: BoxFit.cover,
                                            )
                                          : ColoredBox(color: Theme.of(context).colorScheme.secondary, child: Icon(Icons.book)),
                                    )),
                              ),
                              title: Text(recipe.title ?? 'No title'),
                              subtitle: Text(recipe.description ?? ''),
                              onTap: () {
                                RecipeViewModel.navigateToRecipe(recipe, context);
                              },
                              onLongPress: () async {
                                Rect? rect;
                                RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                                final renderObject = context.findRenderObject();
                                final translation = renderObject?.getTransformTo(null).getTranslation();
                                if (translation != null && renderObject?.paintBounds != null) {
                                  final offset = Offset(translation.x, translation.y);
                                  rect = renderObject!.paintBounds.shift(offset);
                                }
                                if (rect != null) {
                                  var value = await showMenu<String>(
                                    context: context,
                                    position: RelativeRect.fromRect(
                                      rect,
                                      Offset.zero & overlay.size,
                                    ),
                                    items: [
                                      const PopupMenuItem(value: 'remove', child: Text('Remove from Book')),
                                      const PopupMenuItem(value: 'delete', child: Text('Delete Recipe')),
                                    ],
                                  );
                                  if (value != null) {
                                    debugPrint(value);
                                    if (value == 'remove') {
                                      await bookService.removeRecipeFromBook(recipe, bookId);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe removed from book')));
                                    } else if (value == 'delete') {
                                      await RecipeViewModel.deleteRecipe(recipe.recipeId);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe deleted')));
                                    }
                                  }
                                }
                              },
                            );
                          });
                        },
                        childCount: (snapshot.data ?? []).length,
                      ),
                    );
                  } else {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Animate(effects: [ScaleEffect()], child: Image.asset('assets/splash.png', height: 300)),
                            Animate(
                                effects: [
                                  SlideEffect(
                                    begin: Offset(0, 0.5),
                                    end: Offset(0, 0),
                                  ),
                                  FadeEffect()
                                ],
                                child: Text(
                                  'No recipes in this book',
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                                )),
                            gap64,
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ],
        ));
      },
    );
  }
}
