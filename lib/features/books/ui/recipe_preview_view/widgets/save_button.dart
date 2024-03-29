import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/recipe_preview_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipePreviewViewModel model = getModel<RecipePreviewViewModel>(context);
    return ValueListenableBuilder(
      valueListenable: model.errorLoadingRecipe,
      builder: (context, error, child) {
        return Container(
          child: error
              ? null
              : FloatingActionButton.extended(
                  key: const Key('action_button_save'),
                  onPressed: () async {
                    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc();

                    Recipe newRecipe = model.recipe.value!.copyWith(
                      recipeId: ref.id,
                      url: model.url,
                    );

                    await ref.set(newRecipe.toJson());

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Recipe saved!')),
                    );

                    router.pushReplacement('/recipe/${ref.id}');

                    /* bool save = await showModalBottomSheet<bool>(
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
                                          'Save to Book',
                                          style: Theme.of(context).textTheme.headlineSmall,
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
                                                return Center(child: Text('Error: ${snapshot.error}'));
                                              }

                                              if (!snapshot.hasData) {
                                                return Center(child: CircularProgressIndicator());
                                              }
                                              return ListView.builder(
                                                itemBuilder: (context, index) {
                                                  Book book = snapshot.data![index];
                                                  return RadioListTile(
                                                    title: Text(book.title ?? ''),
                                                    value: book.bookId,
                                                    groupValue: bookService.saveToBook.value,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        bookService.setSaveToBook(value);
                                                      });
                                                    },
                                                  );
                                                },
                                                itemCount: snapshot.data!.length,
                                              );
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                                child: Text('Cancel')),
                                            gap16,
                                            OutlinedButton(
                                                onPressed: () async {
                                                  Recipe newRecipe = currentRecipeService.recipe.value!.copyWith(
                                                    bookIds: [bookService.saveToBook.value!],
                                                    url: appService.currentUrl.value,
                                                  );

                                                  bookService.setCheckedBooks([bookService.saveToBook.value ?? '']);
                                                  currentRecipeService.updateRecipe(newRecipe);
                                                  await bookService.addRecipeToBook(newRecipe, bookService.saveToBook.value!);
                                                  bookService.setSaveToBook(null);

                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Recipe saved to book')),
                                                  );
                                                  Navigator.of(context).pop(true);
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
                        ) ??
                        false;*/
                  },
                  label: Text('Save', style: Theme.of(context).textTheme.titleLarge),
                  icon: const Icon(Icons.bookmark_border),
                ),
        );
      },
    );
  }
}
