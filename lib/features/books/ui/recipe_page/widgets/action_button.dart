import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/providers/books_provider.dart';
import 'package:abis_recipes/features/home/providers/loading_provider.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:abis_recipes/main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

class ActionButton extends ConsumerStatefulWidget {
  const ActionButton({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ActionButtonState();
}

class _ActionButtonState extends ConsumerState<ActionButton> {
  bool saved = false;

  @override
  void initState() {
    super.initState();
    saved = isar.recipes.filter().urlEqualTo(ref.read(urlProvider)).findAllSync().isNotEmpty;
    debugPrint('Saved: $saved');
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        child: ref.watch(errorProvider)
            ? null
            : saved
                ? FloatingActionButton.extended(
                    key: const Key('action_button_notes'),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return DecoratedBox(
                            decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                              child: ListView(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Notes',
                                      style: Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('Test'),
                                    onTap: () {
                                      debugPrint('test');
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    label: Text('Notes'),
                    icon: Icon(Icons.sticky_note_2_outlined),
                  )
                : FloatingActionButton.extended(
                    key: const Key('action_button_save'),
                    onPressed: () async {
                      bool save = await showModalBottomSheet<bool>(
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
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          Book book = ref.watch(booksProvider)[index];
                                          return RadioListTile(
                                            title: Text(book.title ?? ''),
                                            value: book.id,
                                            groupValue: ref.watch(saveToBookProvider),
                                            onChanged: (value) {
                                              setState(() {
                                                ref.read(saveToBookProvider.notifier).state = value;
                                              });
                                            },
                                          );
                                        },
                                        itemCount: ref.watch(booksProvider).length,
                                      ),
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
                                                Recipe newRecipe = ref.watch(recipeProvider)!.copyWith(
                                                  bookIds: [ref.watch(saveToBookProvider) ?? 0],
                                                  url: ref.watch(urlProvider),
                                                );

                                                ref.watch(checkedBooksProvider.notifier).state = [ref.watch(saveToBookProvider) ?? 0];
                                                ref.watch(bookRecipesProvider(ref.watch(saveToBookProvider) ?? 0).notifier).addRecipe(newRecipe);
                                                ref.watch(saveToBookProvider.notifier).state = null;
                                                await ref.watch(recipesProvider.notifier).addRecipe(newRecipe);

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
                      ) ?? false;

                      if (save == true) {
                        setState(() {
                          saved = true;
                        });
                      }
                    },
                    label: Text('Save'),
                    icon: const Icon(Icons.bookmark_border),
                  ),
      );
    });
  }
}
