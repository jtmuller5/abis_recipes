import 'dart:convert';
import 'dart:developer';

import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/note.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/services/html_processor.dart';
import 'package:abis_recipes/main.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class RecipePreviewViewModelBuilder extends ViewModelBuilder<RecipePreviewViewModel> {
  const RecipePreviewViewModelBuilder({
    super.key,
    required this.url,
    required super.builder,
  });

  final String url;

  @override
  State<StatefulWidget> createState() => RecipePreviewViewModel(url);
}

class RecipePreviewViewModel extends ViewModel<RecipePreviewViewModel> {
  final String url;

  RecipePreviewViewModel(this.url);

  @override
  void initState() {
    loadingRecipe.value = true;

    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').where('url', isEqualTo: url).get().then((value) {
      if (value.docs.isNotEmpty) {
        router.replace('/recipe/${value.docs.first.id}');
        loadingRecipe.value = false;
      } else {
        loadRecipe(url);
      }
    });
    super.initState();
  }

  ValueNotifier<Recipe?> recipe = ValueNotifier(null);

  ValueNotifier<bool> loadingRecipe = ValueNotifier(false);

  ValueNotifier<bool> errorLoadingRecipe = ValueNotifier(false);

  void setErrorLoadingRecipe(bool val) {
    errorLoadingRecipe.value = val;
  }

  void setLoadingRecipe(bool val) {
    loadingRecipe.value = val;
  }

  void setRecipe(Recipe val) {
    recipe.value = val;
  }

  void clearRecipe() {
    recipe.value = null;
  }

  static List<Note> getAllNotes(Recipe recipe) {
    List<Note> notes = [];

    recipe.ingredients?.forEach((ingredient) {
      if (ingredient.note != null) {
        notes.add(ingredient.note!);
      }
    });

    recipe.instructions?.forEach((instruction) {
      if (instruction.note != null) {
        notes.add(instruction.note!);
      }
    });

    return notes;
  }

  static List<Ingredient> getIngredientsWithNotes(Recipe? recipe) {
    if (recipe == null) return [];
    List<Ingredient> ingredients = [];

    recipe.ingredients?.forEach((ingredient) {
      if (ingredient.note != null) {
        ingredients.add(ingredient);
      }
    });

    return ingredients;
  }

  static List<Instruction> getInstructionsWithNotes(Recipe? recipe) {
    if (recipe == null) return [];
    List<Instruction> instructions = [];

    recipe.instructions?.forEach((instruction) {
      if (instruction.note != null) {
        instructions.add(instruction);
      }
    });

    return instructions;
  }

  void createRecipe(String? url) {
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc();
    setRecipe(Recipe(
      recipeId: ref.id,
      ingredients: [],
      instructions: [],
      url: url,
      bookIds: [],
      coverImage: null,
      description: null,
      images: [],
      title: null,
      createdAt: DateTime.now(),
    ));
  }

  void updateRecipeTitle(String title) => setRecipe(recipe.value!.copyWith(title: title));

  void updateRecipeDescription(String description) => setRecipe(recipe.value!.copyWith(description: description));

  void updateRecipeImage(String? image) => setRecipe(recipe.value!.copyWith(images: [image ?? '']));

  void updateRecipeUrl(String url) => setRecipe(recipe.value!.copyWith(url: url));

  void updateRecipeIngredients(List<Ingredient> ingredients) => setRecipe(recipe.value!.copyWith(ingredients: ingredients));

  void updateRecipeInstructions(List<Instruction> instructions) => setRecipe(recipe.value!.copyWith(instructions: instructions));

  void addInstruction(Instruction instruction) => setRecipe(recipe.value!.copyWith(instructions: [...recipe.value!.instructions!, instruction]));

  void addIngredient(Ingredient ingredient) {
    // Add if not already in list
    if (!recipe.value!.ingredients!.where((element) => element.name == ingredient.name).isNotEmpty) {
      setRecipe(recipe.value!.copyWith(ingredients: [...recipe.value!.ingredients!, ingredient]));
    }
  }

  void removeIngredient(Ingredient ingredient) => setRecipe(recipe.value!.copyWith(ingredients: [...recipe.value!.ingredients!]..remove(ingredient)));

  Future<void> loadRecipe(url) async {
    loadingRecipe.value = true;
    clearRecipe();
    final response = await http.Client().get(Uri.parse(url));

    if (response.statusCode == 200) {
      //Getting the html document from the response
      dom.Document document = parser.parse(response.body);
      try {
        BeautifulSoup bs = BeautifulSoup(document.outerHtml);

        createRecipe(url);
        getTitle(bs, url);
        getImage(bs, url);
        getIngredients(bs, url);
        getInstructions(bs, url);

        if (recipe.value?.title == null || recipe.value?.images == null || (recipe.value?.ingredients ?? []).isEmpty || (recipe.value?.instructions ?? []).isEmpty) {
          errorLoadingRecipe.value = true;
          amplitude.logEvent('bad recipe', eventProperties: {'url': url});
        } else {

          List oldList = [...?sharedPreferences.getStringList('recent_searches')];
          List<String> newList = [url, ...oldList];
          // remove duplicates
          newList = newList.toSet().toList();
          sharedPreferences.setStringList('recent_searches', newList);
          errorLoadingRecipe.value = false;
        }
      } catch (e) {
        debugPrint('Top Error: ' + e.toString());
        errorLoadingRecipe.value = true;
      }
    } else {
      debugPrint('Error: ' + response.statusCode.toString());
    }
    loadingRecipe.value = false;
  }

  void getImage(BeautifulSoup bs, String url, {bool print = false}) {
    Bs4Element? image = bs.img;

    String? imageUrl;

    try {
      if (url.contains('cakeculator')) {
        Bs4Element? cakeDiv = bs.find('*', id: 'Cake-Section');

        Bs4Element? cakeImage = cakeDiv?.find('*', class_: 'post-main-rtb');

        imageUrl = cakeImage?.img?.attributes['src'];
      }

      debugPrint('image: ' + image.toString());
      if (imageUrl == null || !HtmlProcessor.isHttps(imageUrl!)) {
        imageUrl = bs.head?.find('meta', attrs: {'property': 'og:image'})?.attributes['content'];
      }

      if (imageUrl == null || imageUrl == '') {
        if (image?.attributes['src'] != null && image?.attributes['src'] != '') {
          imageUrl = image?.attributes['src'];
          debugPrint('src image: ' + imageUrl.toString());
        } else if (image?.attributes['data-src'] != null && image?.attributes['data-src'] != '') {
          imageUrl = image?.attributes['data-src'];
          debugPrint('data src image: ' + imageUrl.toString());
        } else {
          imageUrl = null;
        }

        if (imageUrl == null || !HtmlProcessor.isHttps(imageUrl)) {
          List<Bs4Element> images = bs.findAll('img');

          images.forEach((element) {
            // debugPrint('image: ' + element.toString());

            if (element.attributes['alt'] != null && element.attributes['alt']?.toLowerCase().contains(recipe.value?.title?.toLowerCase() ?? '') != '') {
              imageUrl = element.attributes['src'];
              debugPrint('img image: ' + imageUrl.toString());
            }
          });
          //debugPrint('image 2: ' + image.toString());
        }

        if (imageUrl != null && !HtmlProcessor.isHttps(imageUrl!)) {
          debugPrint('Video: ' + (bs.find('div').toString()));
          imageUrl = bs.find('*', attrs: {'poster': true})?.attributes['poster'];
        }
      } else {
        debugPrint('Meta image: ' + imageUrl.toString());
      }

      if (print) debugPrint('image: ' + imageUrl.toString());
      updateRecipeImage(imageUrl);
    } catch (e) {
      debugPrint('getImage error: ' + e.toString());
    }
  }

  void getIngredients(BeautifulSoup bs, String url, {bool print = false}) {
    List<Bs4Element>? ingredients = [];
    Bs4Element? ingredientSection;

    /// Handle special cases
    if (url.contains('nytimes')) {
      // regex containing ingredient_ingredient
      String regex = r'ingredient_ingredient';
      ingredients = bs.findAll('*', class_: regex);
      debugPrint('listItems: ' + ingredients.toString());
    } else if (url.contains('foodnetwork')) {
      ingredients = bs.findAll('*', class_: 'o-Ingredients__a-Ingredient--CheckboxLabel');
    } else if (url.contains('bonappetit.com')) {
      ingredientSection = bs.find('*', class_: 'List-WECnc');

      List<Bs4Element>? amounts = ingredientSection?.findAll('*', class_: 'Amount-WYbOy');
      List<Bs4Element>? items = ingredientSection?.findAll('*', class_: 'Description-dSEniY');

      // Combine amounts and items
      for (int i = 0; i < (amounts ?? []).length; i++) {
        String ingredient = amounts![i].text + ' ' + items![i].text;
        addIngredient(Ingredient(name: HtmlProcessor.capitalize(ingredient.trim())));
      }
    }

    if (url.contains('pillsbury.com')) {
      ingredientSection = bs.find('*', class_: 'recipeIngredients primary');
    } else if (url.contains('pioneerwoman')) {
      ingredientSection = bs.find('*', class_: 'eno1xhi3');
    } else {
      ingredientSection = bs.find('*', class_: 'ingredient');
    }

    debugPrint('ingredients: ' + ingredients.toString());

    /// Handle other cases
    if (ingredients.isEmpty) {
      if (ingredientSection?.name == 'li') {
        ingredients = bs.findAll('*', class_: 'ingredient');
      }
      ingredients = ingredientSection?.findAll('li');

      debugPrint('ingredientSection: ' + ingredientSection.toString());
      Bs4Element? ingredientList = ingredientSection?.find('ul', class_: 'ingredient');

      if (ingredientList != null) {
        debugPrint('Ingredient List not null');
        ingredientSection = ingredientList;
      } else {
        ingredientSection = bs.find('*', class_: 'ingredient');
      }

      if ((ingredients ?? []).isEmpty) {
        debugPrint('ingredients is empty');
        ingredients = ingredientSection?.findAll('li');
      }
    }

    /// Look for structured recipe data
    if ((ingredients ?? []).isEmpty) {
      Bs4Element? recipe = bs.find('script', attrs: {'type': 'application/ld+json'});

      Map<String, dynamic> recipeMap = jsonDecode(recipe!.text);

      List<String> ingredientsList = recipeMap['recipeIngredient'].cast<String>();

      ingredientsList.forEach((element) {
        addIngredient(Ingredient(name: HtmlProcessor.capitalize(element)));
      });

      return;
    }

    /// Print ingredients
    try {
      debugPrint('ingredients: ' + ingredients.toString());
    } catch (e) {
      debugPrint('ingredients: ' + e.toString());
    }

    /// Add ingredients to recipe
    ingredients?.forEach((element) {
      String ingredient = HtmlProcessor.removeNewLines(element.text);
      ingredient = HtmlProcessor.removeHtmlTags(ingredient);
      ingredient = HtmlProcessor.removeTabs(ingredient);
      addIngredient(Ingredient(name: HtmlProcessor.capitalize(ingredient.trim())));
    });
  }

  void getInstructions(BeautifulSoup bs, String url, {bool print = false}) {
    List<Bs4Element>? listItems = [];

    /// Handle special cases
    if (url.contains('cakeculator')) {
      listItems = getCakeculatorInstructions(bs);
    } else if (url.contains('foodnetwork')) {
      listItems = bs.findAll('*', class_: 'o-Method__m-Step');
    } else if (url.contains('bonappetit.com')) {
      Bs4Element? instructionSection = bs.find('*', class_: 'InstructionListWrapper');

      listItems = instructionSection?.findAll('p');
    } else {
      Bs4Element? instructions = bs.find('*', class_: 'instruction');

      if (instructions == null) {
        instructions = bs.find('*', class_: 'directions');
        if (instructions == null) instructions = bs.find('*', class_: 'Directions');

        if (instructions != null) log('Found Directions');
      }

      if (instructions == null) {
        instructions = bs.find('*', class_: 'steps');
        if (instructions == null) instructions = bs.find('*', class_: 'Steps');

        if (instructions != null) log('Found Steps');
      }

      /// Look for structured json data
      if (instructions == null) {
        Bs4Element? recipe = bs.find('script', attrs: {'type': 'application/ld+json'});

        Map<String, dynamic> recipeMap = jsonDecode(recipe!.text);

        log(recipeMap.toString());

        List<String> ingredientsList = recipeMap['recipeInstructions'].map((e) => e['text']).cast<String>().toList();

        ingredientsList.forEach((element) {
          addInstruction(Instruction(text: ReCase(element.trim()).sentenceCase + '.'));
        });

        return;
      }

      debugPrint('instructions: ' + instructions.toString());
      listItems = instructions?.findAll('li');
    }

    listItems?.forEach((listItem) {
// log('List Item: ' + removeHtmlTags(element.text));

      // If the list item contains an ordered or unordered list, skip it
      Bs4Element? innerOrderedList = listItem.find('ol');
      Bs4Element? innerUnorderedList = listItem.find('ul');

      if (innerOrderedList != null || innerUnorderedList != null) return;

      String removeSpans = '';

      listItem.findAll('span').forEach((e) {
        if (e.children.isNotEmpty) {
          removeSpans += e.text;
        }
      });

      String instruction = listItem.text.replaceAll(removeSpans, '');

      instruction = HtmlProcessor.removeNewLines(instruction);
      instruction = HtmlProcessor.removeTabs(instruction);
      instruction = HtmlProcessor.removeHtmlTags(instruction);

      listItem.findAll('figcaption').forEach((e) {
        instruction = instruction.replaceAll(e.text, '');
        instruction = instruction.replaceAll(e.text.toLowerCase(), '');
        instruction = instruction.replaceAll(e.text.replaceAll('\n', ''), '');
      });

      String figures = listItem.findAll('figure').map((e) => e.children.map((e) => e.text)).toString();
      //debugPrint('figures: ' + figures.toString());

      // step = step.replaceAll(figures, '');
      instruction = instruction.replaceAll('css-13o7eu2{display:block;}', '');

      if (print) debugPrint('Instructions: ' + instruction);

      addInstruction(Instruction(text: ReCase(instruction.trim()).sentenceCase + '.'));
    });
  }

  List<Bs4Element> getCakeculatorInstructions(BeautifulSoup bs) {
    Bs4Element? instructions = bs.find('ol');

    debugPrint('instructions: ' + instructions.toString());
    return instructions?.findAll('li') ?? [];
  }

  void getTitle(BeautifulSoup bs, String url, {bool print = false}) {
    Bs4Element? title = bs.title;

    if (print) debugPrint('title: ' + title.toString());

    String recipeTitle = title?.text.split('-').first ?? '';
    recipeTitle = recipeTitle.replaceAll('Recipe', '');
    recipeTitle = recipeTitle.replaceAll('recipe', '');

    updateRecipeTitle(recipeTitle.trim());
  }

  static RecipePreviewViewModel of_(BuildContext context) => getModel<RecipePreviewViewModel>(context);
}
