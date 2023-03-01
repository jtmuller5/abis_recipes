import 'dart:developer';
import 'dart:ui';

import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/providers/books_provider.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/recipe_header.dart';
import 'package:abis_recipes/features/home/providers/ingredients_provider.dart';
import 'package:abis_recipes/features/home/providers/loading_provider.dart';
import 'package:abis_recipes/features/home/providers/recipe_image_provider.dart';
import 'package:abis_recipes/features/home/providers/recipe_title_provider.dart';
import 'package:abis_recipes/main.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';

import '../../../home/providers/instructions_provider.dart';

class RecipePage extends ConsumerWidget {
  const RecipePage({Key? key, required this.url}) : super(key: key);

  final String url;

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
                          child: Image.asset('assets/splash.png',
                          height: 300,),
                        ),
                        Animate(
                          effects: [SlideEffect(
                            begin: Offset(0, 0.5),
                            end: Offset(0, 0),
                          )],
                          child: Text(
                            'Error loading recipe',
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        Animate(
                          effects: [SlideEffect(
                            begin: Offset(0, 0.5),
                            end: Offset(0, 0),
                          )],
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
                                url,
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
      floatingActionButton: ref.watch(errorProvider) ? null : FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder:(context, setState) => DecoratedBox(
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
                                        url: url,
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

void getImage(BeautifulSoup bs, WidgetRef ref) {
  Bs4Element? image = bs.img;

  debugPrint('image: ' + image.toString());

  String? imageUrl;

  if (image?.attributes['src'] != null && image?.attributes['src'] != '') {
    imageUrl = image?.attributes['src'];
  } else if (image?.attributes['data-src'] != null && image?.attributes['data-src'] != '') {
    imageUrl = image?.attributes['data-src'];
  } else {
    imageUrl = null;
  }

  if (imageUrl == null || !isHttps(imageUrl)) {
    List<Bs4Element> images = bs.findAll('img');

    images.forEach((element) {
// debugPrint('image: ' + element.toString());

      if (element.attributes['alt'] != null && element.attributes['alt']!.toLowerCase().contains(ref.watch(recipeTitleProvider)!.toLowerCase())) {
        imageUrl = element.attributes['src'];
      }
    });
//debugPrint('image 2: ' + image.toString());
  }

  if (imageUrl != null && !isHttps(imageUrl!)) {
    imageUrl = bs.head?.find('meta', attrs: {'property': 'og:image'})?.attributes['content'];
  }

  if (imageUrl != null && !isHttps(imageUrl!)) {
    debugPrint('Video: ' + (bs.find('div').toString()));
    imageUrl = bs.find('*', attrs: {'poster': true})?.attributes['poster'];
  }

  ref.read(recipeImageProvider.notifier).state = imageUrl;
}

void getTitle(BeautifulSoup bs, WidgetRef ref) {
  Bs4Element? title = bs.title;

  debugPrint('title: ' + title.toString());

  String recipeTitle = title?.text.split('-').first ?? '';
  recipeTitle = recipeTitle.replaceAll('Recipe', '');
  recipeTitle = recipeTitle.replaceAll('recipe', '');

  ref.read(recipeTitleProvider.notifier).state = recipeTitle.trim();
}

void getIngredients(BeautifulSoup bs, WidgetRef ref) {
  Bs4Element? ingredients = bs.find('*', class_: 'ingredient');

  Bs4Element? ingredientList = ingredients?.find('ul', class_: 'ingredient');

  if (ingredientList != null) {
    ingredients = ingredientList;
  }

  List<Bs4Element>? listItems = ingredients?.findAll('li');

  listItems?.forEach((element) {
    // regex for new lines
    RegExp newLines = RegExp('[\r\n]');
    RegExp tabs = RegExp('[\t]');
    String ingredient = element.text.replaceAll(newLines, '');
    ingredient = ingredient.replaceAll(tabs, ' ');
    ref.read(ingredientsProvider.notifier).addIngredient(Ingredient(name: ReCase(ingredient.trim()).titleCase));
  });
}

void getInstructions(BeautifulSoup bs, WidgetRef ref) {
  Bs4Element? instructions = bs.find('*', class_: 'instruction');

  log('Instructions: ' + instructions.toString());

  if (instructions == null) {
    instructions = bs.find('*', class_: 'directions');

    log('Directions: ' + instructions.toString());
  }

  if (instructions == null) {
    instructions = bs.find('*', class_: 'steps');

    log('Steps: ' + instructions.toString());
  }

  List<Bs4Element>? listItems = instructions?.findAll('li');

  listItems?.forEach((element) {
// log('List Item: ' + removeHtmlTags(element.text));

// If the list item contains an ordered or unordered list, skip it
    Bs4Element? innerOrderedList = element.find('ol');
    Bs4Element? innerUnorderedList = element.find('ul');

    if (innerOrderedList != null || innerUnorderedList != null) return;

    String remove = element.findAll('span').map((e) => e.text).join('');

    debugPrint('remove: ' + remove.toString());
    String step = element.text.replaceAll(remove, '');
    step = step.replaceAll('css-13o7eu2{display:block;}', '');

    debugPrint('Before: ' + step);

    ref.read(instructionsProvider.notifier).addInstruction(Instruction(text: ReCase(removeHtmlTags(step).trim()).sentenceCase + '.'));
  });
}

// Function to remove html tags from a string
String removeHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(exp, '');
}

//Function to check if it's string begins with HTTPS
bool isHttps(String url) {
  return url.startsWith('https');
}
