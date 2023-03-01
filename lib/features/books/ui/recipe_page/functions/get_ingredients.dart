import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/services/html_processor.dart';
import 'package:abis_recipes/features/home/providers/ingredients_provider.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recase/recase.dart';

void getIngredients(BeautifulSoup bs, WidgetRef ref, {bool print = false}) {
  Bs4Element? ingredients = bs.find('*', class_: 'ingredient');

  Bs4Element? ingredientList = ingredients?.find('ul', class_: 'ingredient');

  if (ingredientList != null) {
    ingredients = ingredientList;
  }

  List<Bs4Element>? listItems = ingredients?.findAll('li');

  listItems?.forEach((element) {

    String ingredient = HtmlProcessor.removeNewLines(element.text);
    ingredient = HtmlProcessor.removeTabs(ingredient);

    debugPrint('ingredient: ' + ingredient.toString());
    ref.read(ingredientsProvider.notifier).addIngredient(Ingredient(name: HtmlProcessor.capitalize(ingredient.trim())));
  });
}