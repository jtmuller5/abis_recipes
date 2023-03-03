import 'dart:developer';
import 'dart:ui';

import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/gpt_message.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/providers/books_provider.dart';
import 'package:abis_recipes/features/books/services/chat_gpt_service.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/functions/get_image.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/functions/get_ingredients.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/functions/get_instructions.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/functions/get_title.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/ingredient_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/instruction_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/recipe_header.dart';
import 'package:abis_recipes/features/home/providers/loading_provider.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:abis_recipes/main.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';

class RecipePage extends ConsumerWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: ref.watch(loadingRecipeProvider)
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ))
            : ref.watch(errorProvider)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Animate(
                          effects: [ScaleEffect()],
                          child: Image.asset(
                            'assets/splash.png',
                            height: 300,
                          ),
                        ),
                        Animate(
                          effects: [
                            SlideEffect(
                              begin: Offset(0, 0.5),
                              end: Offset(0, 0),
                            )
                          ],
                          child: Text(
                            'Error loading recipe',
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        if (kDebugMode)
                          Column(
                            children: [
                              Text(ref.watch(recipeProvider)?.title ?? ''),
                              Text(ref.watch(recipeProvider)?.images.toString() ?? ''),
                              Text(ref.watch(recipeProvider)?.ingredients.toString() ?? ''),
                              Text(ref.watch(recipeProvider)?.instructions.toString() ?? ''),
                            ],
                          ),
                        Animate(
                          effects: [
                            SlideEffect(
                              begin: Offset(0, 0.5),
                              end: Offset(0, 0),
                            )
                          ],
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Go back',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
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
                                                      child: ListView.builder(
                                                    itemCount: ref.watch(booksProvider).length,
                                                    itemBuilder: (context, index) {
                                                      Book book = ref.watch(booksProvider)[index];

                                                      return CheckboxListTile(
                                                        controlAffinity: ListTileControlAffinity.leading,
                                                        title: Text(
                                                          book.title,
                                                        ),
                                                        value: ref.watch(checkedBooksProvider.notifier).state.contains(book.id),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            if (value!) {
                                                              ref.read(checkedBooksProvider.notifier).state = [
                                                                ...ref.read(checkedBooksProvider.notifier).state,
                                                                book.id
                                                              ];
                                                            } else {
                                                              ref.read(checkedBooksProvider.notifier).state = ref
                                                                  .read(checkedBooksProvider.notifier)
                                                                  .state
                                                                  .where((element) => element != book.id)
                                                                  .toList();
                                                            }
                                                          });
                                                        },
                                                      );
                                                    },
                                                  )),
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
                                                              if (ref.watch(recipeProvider)?.id != null) {
                                                                Recipe newRecipe = Recipe(
                                                                  id: ref.watch(recipeProvider)!.id,
                                                                  bookIds: ref.watch(checkedBooksProvider),
                                                                  title: ref.watch(recipeProvider)?.title,
                                                                  images: ref.watch(recipeProvider)?.images != null
                                                                      ? ref.watch(recipeProvider)!.images!
                                                                      : [],
                                                                  ingredients: ref
                                                                      .watch(recipeProvider)
                                                                      ?.ingredients
                                                                      ?.map((e) => Ingredient(name: e.name))
                                                                      .toList(),
                                                                  instructions: ref
                                                                      .watch(recipeProvider)
                                                                      ?.instructions
                                                                      ?.map((e) => Instruction(text: e.text))
                                                                      .toList(),
                                                                  url: ref.watch(urlProvider),
                                                                );

                                                                ref.watch(checkedBooksProvider).forEach((bookId) {
                                                                  ref.watch(bookRecipesProvider(bookId).notifier).addRecipe(newRecipe);
                                                                });

                                                                await isar.writeTxn(() async {
                                                                  await isar.recipes.put(newRecipe);
                                                                });

                                                                ref.watch(recipeProvider.notifier).updateRecipe(newRecipe);
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
                                            if (ref.watch(recipeProvider)?.url != null &&
                                                isar.recipes.filter().urlContains(ref.watch(recipeProvider)!.url!).findAllSync().isNotEmpty)
                                              const PopupMenuItem(value: 'delete', child: Text('Delete Recipe')),
                                          ],
                                        );
                                        if (value != null) {
                                          debugPrint(value);
                                          if (value == 'reload') {
                                            ref.watch(urlProvider.notifier).state = ref.watch(recipeProvider)?.url;
                                            try {
                                              loadRecipe(ref, ref.watch(urlProvider));
                                            } catch (e) {
                                              debugPrint(e.toString());
                                              ref.read(loadingRecipeProvider.notifier).state = false;
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('Error loading recipe'),
                                              ));
                                            }
                                          } else if (value == 'delete') {
                                            if (ref.watch(recipeProvider)?.url != null) {
                                              List<int> deleteIds = isar.recipes
                                                  .filter()
                                                  .urlContains(ref.watch(recipeProvider)!.url!)
                                                  .findAllSync()
                                                  .map((e) => e.id)
                                                  .toList();

                                              await ref.read(recipeProvider.notifier).deleteRecipes(deleteIds);
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
                          if (ref.watch(recipeProvider)?.title != null && ref.watch(recipeProvider)?.images != null)
                            SliverToBoxAdapter(
                              child: RecipeHeader(
                                ref.watch(recipeProvider)?.title ?? '',
                                ref.watch(recipeProvider)?.images?.firstOrNull ?? '',
                                ref.watch(urlProvider) ?? '',
                              ),
                            ),
                          SliverToBoxAdapter(child: Divider()),
                          if ((ref.watch(recipeProvider)?.ingredients ?? []).isNotEmpty)
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
                          if ((ref.watch(recipeProvider)?.instructions ?? []).isNotEmpty)
                            SliverToBoxAdapter(
                              child: ListTile(
                                title: Text(
                                  'Directions',
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('${ref.watch(recipeProvider)?.instructions!.length} steps'),
                              ),
                            ),
                          InstructionList(),
                          SliverToBoxAdapter(child: gap64),
                        ]),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: ref.watch(errorProvider)
          ? null
          : FloatingActionButton.extended(
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
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel')),
                                    gap16,
                                    OutlinedButton(
                                        onPressed: () async {
                                          Recipe newRecipe = Recipe(
                                            bookIds: [ref.watch(saveToBookProvider) ?? 0],
                                            title: ref.watch(recipeProvider)?.title,
                                            images: ref.watch(recipeProvider)?.images != null ? ref.watch(recipeProvider)!.images! : [],
                                            ingredients: ref.watch(recipeProvider)?.ingredients?.map((e) => Ingredient(name: e.name)).toList(),
                                            instructions: ref.watch(recipeProvider)?.instructions?.map((e) => Instruction(text: e.text)).toList(),
                                            url: ref.watch(urlProvider),
                                          );

                                          ref.watch(checkedBooksProvider.notifier).state = [ref.watch(saveToBookProvider) ?? 0];
                                          ref.watch(bookRecipesProvider(ref.watch(saveToBookProvider) ?? 0).notifier).addRecipe(newRecipe);
                                          ref.watch(saveToBookProvider.notifier).state = null;
                                          await isar.writeTxn(() async {
                                            await isar.recipes.put(newRecipe);
                                          });

                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Recipe saved to book'),
                                          ));
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
              label: Text('Save'),
              icon: const Icon(Icons.bookmark_border),
            ),
    );
  }
}

void setRecipe(WidgetRef ref, Recipe recipe) {
  ref.read(recipeProvider.notifier).updateRecipe(recipe);
}

Future<void> loadRecipe(WidgetRef ref, url) async {
  ref.read(loadingRecipeProvider.notifier).state = true;
  ref.read(recipeProvider.notifier).clearRecipe();
  final response = await http.Client().get(Uri.parse(url));

  if (response.statusCode == 200) {
    //Getting the html document from the response
    dom.Document document = parser.parse(response.body);
    try {
      BeautifulSoup bs = BeautifulSoup(document.outerHtml);

      ref.watch(recipeProvider.notifier).createRecipe(url);
      getTitle(bs, ref);
      getImage(bs, ref);
      getIngredients(bs, ref);
      getInstructions(bs, ref);

      if (ref.watch(recipeProvider)?.title == null ||
          ref.watch(recipeProvider)?.images == null ||
          (ref.watch(recipeProvider)?.ingredients ?? []).isEmpty ||
          (ref.watch(recipeProvider)?.instructions ?? []).isEmpty) {
        ref.watch(errorProvider.notifier).state = true;
      }
    } catch (e) {
      debugPrint('Error: ' + e.toString());
      ref.watch(errorProvider.notifier).state = true;
    }
  } else {
    debugPrint('Error: ' + response.statusCode.toString());
  }
  ref.read(loadingRecipeProvider.notifier).state = false;
}
