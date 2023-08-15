import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/ingredient_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/instruction_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/recipe_error.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/recipe_header.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'recipe_preview_view_model.dart';

class RecipePreviewView extends StatelessWidget {
  const RecipePreviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecipePreviewViewModelBuilder(
      builder: (context, model) {
        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: ValueListenableBuilder(
                valueListenable: appService.loadingRecipe,
                builder: (context, loading, child) {
                  return loading
                      ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ))
                      : ValueListenableBuilder(
                      valueListenable: appService.hasError,
                      builder: (context, error, child) {
                        return error
                            ? RecipeError()
                            : Stack(
                          children: [
                            /*Image.network(
                                    ref.watch(recipeImageProvider) ?? '',
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    alignment: Alignment.topCenter,
                                  ),
                                  Positioned.fill(
                                      child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        stops: [0.8, 1],
                                        colors: [
                                          Colors.white,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  )),*/
                            Animate(
                              effects: [FadeEffect()],
                              child: CustomScrollView(slivers: [
                                SliverAppBar(
                                  leading: BackButton(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  elevation: 0,
                                  backgroundColor: Theme.of(context).colorScheme.background,
                                ),
                                if (currentRecipeService.recipe.value?.title != null && currentRecipeService.recipe.value?.images != null)
                                  SliverToBoxAdapter(
                                    child: RecipeHeader(
                                      currentRecipeService.recipe.value?.title ?? '',
                                      currentRecipeService.recipe.value?.images?.firstOrNull ?? '',
                                      appService.currentUrl.value ?? '',
                                    ),
                                  ),
                                SliverToBoxAdapter(child: Divider()),
                                if ((currentRecipeService.recipe.value?.ingredients ?? []).isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Ingredients',
                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                IngredientList(),
                                SliverToBoxAdapter(child: Divider()),
                                if ((currentRecipeService.recipe.value?.instructions ?? []).isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: ListTile(
                                      title: Text(
                                        'Directions',
                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text('${currentRecipeService.recipe.value?.instructions!.length} steps'),
                                    ),
                                  ),
                                InstructionList(),
                                SliverToBoxAdapter(child: gap64),
                              ]),
                            ),
                          ],
                        );
                      });
                }),
          ),
          floatingActionButton: SaveButton(),
        );
      },
    );
  }
}