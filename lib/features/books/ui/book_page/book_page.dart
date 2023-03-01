import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/providers/books_provider.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/recipe_page.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';

class BookPage extends ConsumerWidget {
  const BookPage({Key? key, required this.bookId}) : super(key: key);

  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(ref.watch(bookProvider(bookId))?.title ?? 'No title'),
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
                            TextEditingController bookTitleController = TextEditingController(text: ref.watch(bookProvider(bookId))?.title);
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
                                    Book? updatedBook = ref.read(bookProvider(bookId));
                                    if (updatedBook == null) return;

                                    debugPrint('updatedBook: ' + updatedBook.title.toString());
                                    debugPrint('bookId: ' + bookId.toString());
                                    debugPrint('updatedBook.id: ' + updatedBook.id.toString());

                                    Book newBook = Book(
                                      id: updatedBook.id,
                                      title: bookTitleController.text,
                                      dateCreated: updatedBook.dateCreated,
                                      url: updatedBook.url,
                                    );
                                    ref.read(bookProvider(updatedBook.id).notifier).updateBook(newBook);
                                    await ref.read(booksProvider.notifier).updateBook(newBook);

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
                                    await ref.read(booksProvider.notifier).deleteBook(bookId);
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
        if (ref.watch(bookRecipesProvider(bookId)).length > 0)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Recipe recipe = ref.watch(bookRecipesProvider(bookId))[index];
                return Builder(
                  builder: (context) {
                    return ListTile(
                      leading: Hero(
                        tag: 'recipe-${recipe.id}',
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
                        setRecipe(ref, recipe);
                        ref.watch(checkedBooksProvider.notifier).state = recipe.bookIds;
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipePage()));
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
                            if(value == 'remove'){
                              await ref.read(bookRecipesProvider(bookId).notifier).removeRecipe(recipe);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe removed from book')));
                            } else if (value == 'delete') {
                              ref.watch(recipeProvider.notifier).updateRecipe(recipe);
                              await ref.read(recipeProvider.notifier).deleteRecipes([recipe.id]);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe deleted')));
                            }
                          }
                        }
                      },
                    );
                  }
                );
              },
              childCount: ref.watch(bookRecipesProvider(bookId)).length,
            ),
          )
        else
          SliverFillRemaining(
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
          )
      ],
    ));
  }
}
