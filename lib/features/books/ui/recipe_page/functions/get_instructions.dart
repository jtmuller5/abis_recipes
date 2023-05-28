import 'dart:convert';
import 'dart:developer';

import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/services/html_processor.dart';
import 'package:abis_recipes/features/home/providers/loading_provider.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recase/recase.dart';

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
  } else if (url.contains('americastestkitchen')) {
    debugPrint('testkitchen');
    Bs4Element? recipe = bs.find('script', attrs: {'type': 'application/ld+json'});

    Map<String, dynamic> recipeMap= jsonDecode(recipe!.text);

    log(recipeMap.toString());

    List<String> ingredientsList = recipeMap['recipeInstructions'].map((e) => e['text']).cast<String>().toList();

    ingredientsList.forEach((element) {
      ref.read(recipeProvider.notifier).addInstruction(Instruction(text: ReCase(element.trim()).sentenceCase + '.'));
    });

    return;
  }else {
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
