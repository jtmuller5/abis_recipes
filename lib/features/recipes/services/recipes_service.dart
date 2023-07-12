import 'package:abis_recipes/main.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RecipesService {

  ValueNotifier<bool> loadingRecipe = ValueNotifier(false);

  ValueNotifier<bool> errorLoadingRecipe = ValueNotifier(false);

  void setErrorLoadingRecipe(bool val){
    errorLoadingRecipe.value = val;
  }

  void setLoadingRecipe(bool val){
    loadingRecipe.value = val;
  }

  Future<void> loadRecipe(url) async {
    loadingRecipe.value = true;
    ref.read(recipeProvider.notifier).clearRecipe();
    final response = await http.Client().get(Uri.parse(url));

    if (response.statusCode == 200) {
      //Getting the html document from the response
      dom.Document document = parser.parse(response.body);
      try {
        BeautifulSoup bs = BeautifulSoup(document.outerHtml);

        ref.watch(recipeProvider.notifier).createRecipe(url);
        getTitle(bs, ref, url);
        getImage(bs, ref, url);
        getIngredients(bs, ref, url);
        getInstructions(bs, ref, url);

        if (ref.watch(recipeProvider)?.title == null ||
            ref.watch(recipeProvider)?.images == null ||
            (ref.watch(recipeProvider)?.ingredients ?? []).isEmpty ||
            (ref.watch(recipeProvider)?.instructions ?? []).isEmpty) {
          errorLoadingRecipe.value = true;
          amplitude.logEvent('bad recipe', eventProperties: {'url': url});
        } else {
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

  void getImage(BeautifulSoup bs, WidgetRef ref,String url, {bool print = false}) {
    Bs4Element? image = bs.img;

    String? imageUrl;

    try {

      if(url.contains('cakeculator')){
        Bs4Element? cakeDiv = bs.find('*',id: 'Cake-Section');

        Bs4Element? cakeImage = cakeDiv?.find('*',class_: 'post-main-rtb');

        imageUrl = cakeImage?.img?.attributes['src'];
      }

      debugPrint('image: ' + image.toString());
      if(imageUrl == null || !HtmlProcessor.isHttps(imageUrl!)){
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

            if (element.attributes['alt'] != null &&
                element.attributes['alt']?.toLowerCase().contains(ref.watch(recipeProvider)?.title?.toLowerCase() ?? '') != '') {
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
      ref.read(recipeProvider.notifier).updateRecipeImage(imageUrl);
    } catch (e) {
      debugPrint('getImage error: ' + e.toString());
    }
  }

  void getIngredients(BeautifulSoup bs, WidgetRef ref, String url, {bool print = false}) {
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
        ref.read(recipeProvider.notifier).addIngredient(Ingredient(name: HtmlProcessor.capitalize(ingredient.trim())));
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
    if((ingredients ?? []).isEmpty){
      Bs4Element? recipe = bs.find('script', attrs: {'type': 'application/ld+json'});

      Map<String, dynamic> recipeMap= jsonDecode(recipe!.text);

      List<String> ingredientsList = recipeMap['recipeIngredient'].cast<String>();

      ingredientsList.forEach((element) {
        ref.read(recipeProvider.notifier).addIngredient(Ingredient(name: HtmlProcessor.capitalize(element)));
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
      ref.read(recipeProvider.notifier).addIngredient(Ingredient(name: HtmlProcessor.capitalize(ingredient.trim())));
    });
  }

  void getInstructions(BeautifulSoup bs, WidgetRef ref, String url, {bool print = false}) {
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
      if(instructions == null){
        Bs4Element? recipe = bs.find('script', attrs: {'type': 'application/ld+json'});

        Map<String, dynamic> recipeMap= jsonDecode(recipe!.text);

        log(recipeMap.toString());

        List<String> ingredientsList = recipeMap['recipeInstructions'].map((e) => e['text']).cast<String>().toList();

        ingredientsList.forEach((element) {
          ref.read(recipeProvider.notifier).addInstruction(Instruction(text: ReCase(element.trim()).sentenceCase + '.'));
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

      ref.read(recipeProvider.notifier).addInstruction(Instruction(text: ReCase(instruction.trim()).sentenceCase + '.'));
    });
  }

  List<Bs4Element> getCakeculatorInstructions(BeautifulSoup bs) {
    Bs4Element? instructions = bs.find('ol');

    debugPrint('instructions: ' + instructions.toString());
    return instructions?.findAll('li') ?? [];
  }

  void getTitle(BeautifulSoup bs, WidgetRef ref,String url, {bool print = false}) {
    Bs4Element? title = bs.title;

    if(print)debugPrint('title: ' + title.toString());

    String recipeTitle = title?.text.split('-').first ?? '';
    recipeTitle = recipeTitle.replaceAll('Recipe', '');
    recipeTitle = recipeTitle.replaceAll('recipe', '');

    ref.read(recipeProvider.notifier).updateRecipeTitle(recipeTitle.trim());
  }
}