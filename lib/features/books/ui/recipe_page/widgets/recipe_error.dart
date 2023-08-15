import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/url_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecipeError extends StatelessWidget {
  const RecipeError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Animate(
              effects: [ScaleEffect()],
              child: Image.asset(
                'assets/splash.png',
                height: 300,
              ),
            ),
          ),
          Animate(
            effects: [
              SlideEffect(
                begin: Offset(0, 0.5),
                end: Offset(0, 0),
              )
            ],
            child: Text(
              'We couldn\'t find a recipe here',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          gap32,
          Animate(
            effects: [
              SlideEffect(
                begin: Offset(0, 0.5),
                end: Offset(0, 0),
              )
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'This can happen if the web page actually doesn\'t contain a recipe, or if the recipe is not in a format we can understand.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(currentRecipeService.recipe.value?.title ?? ''),
                  Text(currentRecipeService.recipe.value?.images.toString() ?? ''),
                  Text(currentRecipeService.recipe.value?.ingredients.toString() ?? ''),
                  Text(currentRecipeService.recipe.value?.instructions.toString() ?? ''),
                ],
              ),
            ),
          UrlButton(),
          Animate(
            effects: [
              SlideEffect(
                begin: Offset(0, 0.5),
                end: Offset(0, 0),
              )
            ],
            child: TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text(
                'Go back',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
