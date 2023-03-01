import 'dart:developer';
import 'dart:ui';

import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/providers/books_provider.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/functions/get_image.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/functions/get_ingredients.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/functions/get_instructions.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/functions/get_title.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/recipe_header.dart';
import 'package:abis_recipes/features/home/providers/ingredients_provider.dart';
import 'package:abis_recipes/features/home/providers/loading_provider.dart';
import 'package:abis_recipes/features/home/providers/recipe_image_provider.dart';
import 'package:abis_recipes/features/home/providers/recipe_title_provider.dart';
import 'package:abis_recipes/main.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../../../home/providers/instructions_provider.dart';

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
                              Text(ref.watch(recipeTitleProvider) ?? ''),
                              Text(ref.watch(recipeImageProvider) ?? ''),
                              Text(ref.watch(ingredientsProvider).toString()),
                              Text(ref.watch(instructionsProvider).toString()),
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
                            backgroundColor: Colors.transparent,
                          ),
                          if (ref.watch(recipeTitleProvider) != null && ref.watch(recipeImageProvider) != null)
                            SliverToBoxAdapter(
                              child: RecipeHeader(
                                ref.watch(recipeTitleProvider) ?? '',
                                ref.watch(recipeImageProvider) ?? '',
                                ref.watch(urlProvider) ?? '',
                              ),
                            ),
                          SliverToBoxAdapter(child: Divider()),
                          if (ref.watch(ingredientsProvider).isNotEmpty)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Ingredients',
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                Ingredient ingredient = ref.watch(ingredientsProvider)[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        ingredient.name ?? '',
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                                      ),
                                    ),
                                    // Divider
                                    if (index != ref.watch(ingredientsProvider).length - 1)
                                      Divider(
                                        height: 4,
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                      ),
                                  ],
                                );
                              },
                              childCount: ref.watch(ingredientsProvider).length,
                            ),
                          ),
                          SliverToBoxAdapter(child: Divider()),
                          if (ref.watch(instructionsProvider).isNotEmpty)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Directions',
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                Instruction instruction = ref.watch(instructionsProvider)[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                  minLeadingWidth: 0,
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    child: Center(
                                      child: Text('${index + 1}',
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                                    ),
                                  ),
                                  title: Text(
                                    instruction.text ?? '',
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                                  ),
                                );
                              },
                              childCount: ref.watch(instructionsProvider).length,
                            ),
                          ),
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
                                          await isar.writeTxn(() async {
                                            Recipe newRecipe = Recipe(
                                              bookIds: [ref.watch(saveToBookProvider) ?? 0],
                                              title: ref.watch(recipeTitleProvider),
                                              images: [ref.watch(recipeImageProvider) != null ? ref.watch(recipeImageProvider)! : ''],
                                              ingredients: ref.watch(ingredientsProvider).map((e) => Ingredient(name: e.name)).toList(),
                                              instructions: ref.watch(instructionsProvider).map((e) => Instruction(text: e.text)).toList(),
                                              url: ref.watch(urlProvider),
                                            );
                                            await isar.recipes.put(newRecipe);
                                          });
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

void setRecipe(WidgetRef ref,Recipe recipe){
  ref.read(recipeTitleProvider.notifier).state = recipe.title;
  ref.read(recipeImageProvider.notifier).state = recipe.images?[0] ?? null;
  ref.read(ingredientsProvider.notifier).setIngredients(recipe.ingredients ?? []);
  ref.read(instructionsProvider.notifier).setInstructions(recipe.instructions ?? []);
}

Future<void> loadRecipe(WidgetRef ref, url) async {
  ref.read(loadingRecipeProvider.notifier).state = true;
  ref.read(ingredientsProvider.notifier).clearIngredients();
  ref.read(instructionsProvider.notifier).clearInstructions();
  ref.read(recipeTitleProvider.notifier).state = null;
  ref.read(recipeImageProvider.notifier).state = null;
  final response = await http.Client().get(Uri.parse(url));

  if (response.statusCode == 200) {
    //Getting the html document from the response
    dom.Document document = parser.parse(response.body);
    try {
      BeautifulSoup bs = BeautifulSoup(document.outerHtml);

      getTitle(bs, ref);
      getImage(bs, ref);
      getIngredients(bs, ref);
      getInstructions(bs, ref);

      if (ref.watch(recipeTitleProvider) == null ||
          ref.watch(recipeImageProvider) == null ||
          ref.watch(ingredientsProvider).isEmpty ||
          ref.watch(instructionsProvider).isEmpty) {
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
