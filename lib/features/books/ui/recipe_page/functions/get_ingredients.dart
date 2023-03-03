import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/services/html_processor.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void getIngredients(BeautifulSoup bs, WidgetRef ref, String url, {bool print = false}) {
  Bs4Element? ingredients = bs.find('*', class_: 'ingredient');

  List<Bs4Element>? listItems = [];
  if (ingredients?.name == 'li') {
    listItems = bs.findAll('*', class_: 'ingredient');
  }
  Bs4Element? ingredientList = ingredients?.find('ul', class_: 'ingredient');

  if (ingredientList != null) {
    debugPrint('Ingredient List not null');
    ingredients = ingredientList;
  }

  if (listItems.isEmpty) {
    listItems = ingredients?.findAll('li');
  }

  listItems?.forEach((element) {
    String ingredient = HtmlProcessor.removeNewLines(element.text);
    ingredient = HtmlProcessor.removeHtmlTags(ingredient);
    ingredient = HtmlProcessor.removeTabs(ingredient);

    //debugPrint('ingredient: ' + ingredient.toString());
    ref.read(recipeProvider.notifier).addIngredient(Ingredient(name: HtmlProcessor.capitalize(ingredient.trim())));
  });
}
