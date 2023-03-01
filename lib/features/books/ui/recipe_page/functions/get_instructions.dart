import 'dart:developer';

import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/services/html_processor.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recase/recase.dart';

void getInstructions(BeautifulSoup bs, WidgetRef ref, {bool print = false}) {
  Bs4Element? instructions = bs.find('*', class_: 'instruction');

  if (instructions == null) {
    instructions = bs.find('*', class_: 'directions');

    log('Found Directions');
  }

  if (instructions == null) {
    instructions = bs.find('*', class_: 'steps');

    log('Found Steps');
  }

  List<Bs4Element>? listItems = instructions?.findAll('li');

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
