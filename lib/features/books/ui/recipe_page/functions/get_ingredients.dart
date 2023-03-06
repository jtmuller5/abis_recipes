import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/services/html_processor.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void getIngredients(BeautifulSoup bs, WidgetRef ref, String url, {bool print = false}) {

  List<Bs4Element>? ingredients = [];
  Bs4Element? ingredientSection;

  /// Handle special cases
  if (url.contains('nytimes')) {
    // regex containing ingredient_ingredient
    String regex = r'ingredient_ingredient';
    ingredients = bs.findAll('*', class_: regex);
    debugPrint('listItems: ' + ingredients.toString());
  } else if(url.contains('foodnetwork')){
    ingredients = bs.findAll('*', class_: 'o-Ingredients__a-Ingredient--CheckboxLabel');
  } else if(url.contains('bonappetit.com')){
    ingredientSection = bs.find('*', class_: 'List-WECnc');

    List<Bs4Element>? amounts = ingredientSection?.findAll('*', class_: 'Amount-WYbOy');
    List<Bs4Element>? items = ingredientSection?.findAll('*', class_: 'Description-dSEniY');

    // Combine amounts and items
    for(int i = 0; i < (amounts ?? []).length; i++){
      String ingredient = amounts![i].text + ' ' + items![i].text;
      ref.read(recipeProvider.notifier).addIngredient(Ingredient(name: HtmlProcessor.capitalize(ingredient.trim())));
    }
  }

  if(url.contains('pillsbury.com')){
    ingredientSection = bs.find('*', class_: 'recipeIngredients primary');
  }else if(url.contains('pioneerwoman')){
    ingredientSection = bs.find('*', class_: 'eno1xhi3');
  }else {
    ingredientSection = bs.find('*', class_: 'ingredient');
  }


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
