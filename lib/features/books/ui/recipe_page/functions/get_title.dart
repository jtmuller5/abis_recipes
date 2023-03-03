import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void getTitle(BeautifulSoup bs, WidgetRef ref,String url, {bool print = false}) {
  Bs4Element? title = bs.title;

  if(print)debugPrint('title: ' + title.toString());

  String recipeTitle = title?.text.split('-').first ?? '';
  recipeTitle = recipeTitle.replaceAll('Recipe', '');
  recipeTitle = recipeTitle.replaceAll('recipe', '');

  ref.read(recipeProvider.notifier).updateRecipeTitle(recipeTitle.trim());
}