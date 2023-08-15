import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/ingredient_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/instruction_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/notes_button.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/recipe_error.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/recipe_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it_mixin/get_it_mixin.dart';


class RecipeView extends StatelessWidget with GetItMixin {
  RecipeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: ValueListenableBuilder(
            valueListenable: appService.loadingRecipe,
            builder: (context, loading, child) {
              return loading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ))
                  : ValueListenableBuilder(
                      valueListenable: appService.hasError,
                      builder: (context, error, child) {
                        return error
                            ? RecipeError()
                            : Stack(
                                children: [
                                  /*Image.network(
                                    ref.watch(recipeImageProvider) ?? '',
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    alignment: Alignment.topCenter,
                                  ),
                                  Positioned.fill(
                                      child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        stops: [0.8, 1],
                                        colors: [
                                          Colors.white,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  )),*/
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
                                                                          if (currentRecipeService.recipe.value?.recipeId != null) {

                                                                            Recipe newRecipe = Recipe(
                                                                              coverImage: null,
                                                                              description: null,
                                                                              bookIds: bookService.checkedBooks.value,
                                                                              title: currentRecipeService.recipe.value?.title,
                                                                              images: currentRecipeService.recipe.value?.images != null ? currentRecipeService.recipe.value!.images! : [],
                                                                              ingredients: currentRecipeService.recipe.value?.ingredients?.map((e) => Ingredient(name: e.name)).toList(),
                                                                              instructions: currentRecipeService.recipe.value?.instructions?.map((e) => Instruction(text: e.text)).toList(),
                                                                              url: appService.currentUrl.value,
                                                                              recipeId: currentRecipeService.recipe.value!.recipeId,
                                                                            );

                                                                            bookService.checkedBooks.value.forEach((bookId) {
                                                                              bookService.addRecipeToBook(newRecipe, bookId);
                                                                            });

                                                                            currentRecipeService.updateRecipe(newRecipe);
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
                                                        const PopupMenuItem(value: 'reload', child: Text('Reload Recipe')),
                                                        if (currentRecipeService.recipe.value?.url != null)
                                                          const PopupMenuItem(value: 'delete', child: Text('Delete Recipe')),
                                                      ],
                                                    );
                                                    if (value != null) {
                                                      debugPrint(value);
                                                      if (value == 'reload') {
                                                        appService.setCurrentUrl(currentRecipeService.recipe.value?.url);
                                                        try {
                                                          recipesService.loadRecipe(appService.currentUrl.value);
                                                        } catch (e) {
                                                          debugPrint(e.toString());
                                                          appService.setLoadingRecipe(false);
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text('Error loading recipe'),
                                                          ));
                                                        }
                                                      } else if (value == 'delete') {
                                                        if (appService.currentUrl.value != null) {

                                                          await currentRecipeService.deleteRecipe(currentRecipeService.recipe.value!.recipeId);
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
                                      if (currentRecipeService.recipe.value?.title != null && currentRecipeService.recipe.value?.images != null)
                                        SliverToBoxAdapter(
                                          child: RecipeHeader(
                                            currentRecipeService.recipe.value?.title ?? '',
                                            currentRecipeService.recipe.value?.images?.firstOrNull ?? '',
                                            appService.currentUrl.value ?? '',
                                          ),
                                        ),
                                      SliverToBoxAdapter(child: Divider()),
                                      if ((currentRecipeService.recipe.value?.ingredients ?? []).isNotEmpty)
                                        SliverToBoxAdapter(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Ingredients',
                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      IngredientList(),
                                      SliverToBoxAdapter(child: Divider()),
                                      if ((currentRecipeService.recipe.value?.instructions ?? []).isNotEmpty)
                                        SliverToBoxAdapter(
                                          child: ListTile(
                                            title: Text(
                                              'Directions',
                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text('${currentRecipeService.recipe.value?.instructions!.length} steps'),
                                          ),
                                        ),
                                      InstructionList(),
                                      SliverToBoxAdapter(child: gap64),
                                    ]),
                                  ),
                                ],
                              );
                      });
            }),
      ),
      floatingActionButton: NotesButton(),
    );
  }
}
