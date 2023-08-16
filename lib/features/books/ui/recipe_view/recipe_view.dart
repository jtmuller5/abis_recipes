import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/preview_ingredient_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/preview_instruction_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/widgets/ingredient_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/widgets/instruction_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/widgets/notes_button.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/recipe_header.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/recipe_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecipeView extends StatelessWidget {
  RecipeView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return RecipeViewModelBuilder(
      builder: (context, model) {
        return StreamBuilder<Recipe>(
              stream:
                  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(id).snapshots().map((event) => Recipe.fromJson(event.data()!)),
              builder: (context, snapshot) {
                return Scaffold(
                  body: Builder(
                    builder:(context) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ));
                      }

                      Recipe? recipe = snapshot.data;
                      return Stack(
                        children: [
                          Animate(
                            effects: [FadeEffect()],
                            child: CustomScrollView(slivers: [
                              SliverAppBar(
                                leading: BackButton(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                elevation: 0,
                                backgroundColor: Theme.of(context).colorScheme.background,
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) => DecoratedBox(
                                                decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          'Select Recipe Books',
                                                          style: Theme.of(context).textTheme.headlineMedium,
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: StreamBuilder<List<Book>>(
                                                              stream: FirebaseFirestore.instance
                                                                  .collection('users')
                                                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                                                  .collection('books')
                                                                  .snapshots()
                                                                  .map((event) => event.docs.map((e) => Book.fromJson(e.data())).toList()),
                                                              builder: (context, snapshot) {
                                                                if (snapshot.hasError) {
                                                                  return Center(
                                                                    child: Text('Error loading books'),
                                                                  );
                                                                }

                                                                if (!snapshot.hasData || snapshot.data == null) {
                                                                  return Center(
                                                                    child: CircularProgressIndicator(
                                                                      color: Theme.of(context).colorScheme.primary,
                                                                    ),
                                                                  );
                                                                }

                                                                return ListView.builder(
                                                                  itemCount: snapshot.data!.length,
                                                                  itemBuilder: (context, index) {
                                                                    Book book = snapshot.data![index];

                                                                    return CheckboxListTile(
                                                                      controlAffinity: ListTileControlAffinity.leading,
                                                                      title: Text(
                                                                        book.title,
                                                                      ),
                                                                      value: bookService.checkedBooks.value.contains(book.bookId),
                                                                      onChanged: (value) {
                                                                        setState(() {
                                                                          if (value!) {
                                                                            bookService.setCheckedBooks([...bookService.checkedBooks.value, book.bookId]);
                                                                          } else {
                                                                            bookService.setCheckedBooks(bookService.checkedBooks.value.where((element) => element != book.bookId).toList());
                                                                          }
                                                                        });
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              })),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text('Cancel')),
                                                            gap16,
                                                            OutlinedButton(
                                                                onPressed: () async {
                                                                  if (recipe?.recipeId != null) {
                                                                    Recipe newRecipe = Recipe(
                                                                      coverImage: null,
                                                                      description: null,
                                                                      bookIds: bookService.checkedBooks.value,
                                                                      title: recipe?.title,
                                                                      images: recipe?.images != null ? recipe!.images! : [],
                                                                      ingredients: recipe?.ingredients?.map((e) => Ingredient(name: e.name)).toList(),
                                                                      instructions: recipe?.instructions?.map((e) => Instruction(text: e.text)).toList(),
                                                                      url: recipe?.url,
                                                                      recipeId: recipe!.recipeId,
                                                                    );

                                                                    bookService.checkedBooks.value.forEach((bookId) {
                                                                      bookService.addRecipeToBook(newRecipe, bookId);
                                                                    });

                                                                    model.updateRecipe(newRecipe);
                                                                  }
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text('Save'))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.book)),
                                  Builder(builder: (context) {
                                    return IconButton(
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
                                                const PopupMenuItem(value: 'delete', child: Text('Delete Recipe')),
                                              ],
                                            );
                                            if (value != null) {
                                              debugPrint(value);
                                              if (value == 'delete') {
                                                if (recipe != null) {
                                                  await RecipeViewModel.deleteRecipe(recipe.recipeId);
                                                  Navigator.pop(context);
                                                }
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          }
                                        },
                                        icon: Icon(Icons.more_vert));
                                  })
                                ],
                              ),
                              if (recipe?.title != null && recipe?.images != null)
                                SliverToBoxAdapter(
                                  child: RecipeHeader(
                                    recipe?.title ?? '',
                                    recipe?.images?.firstOrNull ?? '',
                                    recipe?.url ?? '',
                                  ),
                                ),
                              SliverToBoxAdapter(child: Divider()),
                              if ((recipe?.ingredients ?? []).isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Ingredients',
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              if (recipe != null) IngredientList(recipe: recipe),
                              SliverToBoxAdapter(child: Divider()),
                              if ((recipe?.instructions ?? []).isNotEmpty)
                                SliverToBoxAdapter(
                                  child: ListTile(
                                    title: Text(
                                      'Directions',
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text('${recipe?.instructions!.length} steps'),
                                  ),
                                ),
                              if(snapshot.data != null )InstructionList(recipe: snapshot.data!),
                              SliverToBoxAdapter(child: gap64),
                            ]),
                          ),
                        ],
                      );
                    },
                  ),
                  floatingActionButton: (snapshot.hasData && snapshot.data != null)?  NotesButton(recipe: snapshot.data): null,
                );

              }

        );
      },
    );
  }
}
