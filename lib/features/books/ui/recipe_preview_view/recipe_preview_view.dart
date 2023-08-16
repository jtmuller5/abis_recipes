import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/preview_ingredient_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/preview_instruction_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/recipe_error.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/recipe_header.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'recipe_preview_view_model.dart';

class RecipePreviewView extends StatelessWidget {
  RecipePreviewView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return RecipePreviewViewModelBuilder(
      url: url,
      builder: (context, model) {
        return ValueListenableBuilder(
            valueListenable: model.recipe,
            builder: (context, recipe, child) {
              return ValueListenableBuilder(
                  valueListenable: model.loadingRecipe,
                  builder: (context, loading, child) {
                  return Scaffold(
                    body: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child:  loading
                          ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ))
                          : ValueListenableBuilder(
                          valueListenable: model.errorLoadingRecipe,
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
                                    if (recipe?.title != null && recipe?.images != null)
                                      SliverToBoxAdapter(
                                        child: RecipeHeader(
                                          recipe?.title ?? '',
                                          recipe?.images?.firstOrNull ?? '',
                                          searchService.url.value ?? '',
                                        ),
                                      ),
                                    SliverToBoxAdapter(child: Divider()),
                                    if ((recipe?.ingredients ?? []).isNotEmpty)
                                      SliverToBoxAdapter(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Ingredients',
                                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    if (recipe != null) PreviewIngredientList(recipe: recipe),
                                    SliverToBoxAdapter(child: Divider()),
                                    if ((recipe?.instructions ?? []).isNotEmpty)
                                      SliverToBoxAdapter(
                                        child: ListTile(
                                          title: Text(
                                            'Directions',
                                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text('${recipe?.instructions!.length} steps'),
                                        ),
                                      ),
                                    PreviewInstructionList(),
                                    SliverToBoxAdapter(child: gap64),
                                  ]),
                                ),
                              ],
                            );
                          }),
                    ),
                    floatingActionButton: loading ?null: SaveButton(),
                  );
                }
              );
            });
      },
    );
  }
}
