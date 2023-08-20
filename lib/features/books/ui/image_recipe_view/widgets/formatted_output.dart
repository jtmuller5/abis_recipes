import 'dart:convert';

import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/image_recipe_view/image_recipe_view_model.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/preview_ingredient_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/preview_instruction_list.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

class FormattedOutput extends StatelessWidget {
  const FormattedOutput({Key? key, required this.rawText}) : super(key: key);

  final String rawText;

  @override
  Widget build(BuildContext context) {
    
   ImageRecipeViewModel model = getModel<ImageRecipeViewModel>(context);

   Recipe? recipe = model.getRecipeFromOutput(rawText);

   if(recipe == null) {
     return const Center(child: Text('Error parsing recipe'));
   }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: ListTile(title: Text(recipe.title ?? '',
          style: Theme.of(context).textTheme.headlineMedium,
        ),),),
        SliverToBoxAdapter(
          child: ListTile(
            title: Text(
              'Ingredients',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        PreviewIngredientList(ingredients: recipe.ingredients?.map((e) => e.name!).toList() ?? []),
        SliverToBoxAdapter(child: Divider()),
        SliverToBoxAdapter(
          child: ListTile(
            title: Text(
              'Directions',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${recipe.instructions!.length} steps'),
          ),
        ),
        PreviewInstructionList(instructions: recipe.instructions?.map((e) => e.text!).toList() ?? []),

      ],
    );
  }
}
