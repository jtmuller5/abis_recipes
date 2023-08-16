import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/recipe_preview_view_model.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/recipe_view_model.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

class NotesButton extends StatelessWidget {
  const NotesButton({Key? key, required this.recipe}) : super(key: key);

  final Recipe? recipe;

  @override
  Widget build(BuildContext context) {

    RecipeViewModel model = getModel<RecipeViewModel>(context);

    if(recipe == null) return Container();
    return FloatingActionButton.extended(
      key: const Key('action_button_notes'),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return DecoratedBox(
              decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ListTile(
                        title: Text(
                          'Notes',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Divider(),
                    ),
                    if (RecipePreviewViewModel.getIngredientsWithNotes(recipe).isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: ListTile(
                          title: Text(
                            'Ingredients',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            Ingredient ingredient = RecipePreviewViewModel.getIngredientsWithNotes(recipe)[index];
                            return ListTile(
                              title: Text(ingredient.name ?? ''),
                              subtitle: Text(ingredient.note?.text ?? ''),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  if(recipe == null) return;
                                  Ingredient updatedIngredient = ingredient.copyWithNoNote();

                                  model.updateIngredient(updatedIngredient, recipe!);

                                  router.pop(context);
                                },
                              ),
                            );
                          },
                          childCount: RecipePreviewViewModel.getIngredientsWithNotes(recipe).length,
                        ),
                      )
                    ],
                    if (RecipePreviewViewModel.getInstructionsWithNotes(recipe).isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: ListTile(
                          title: Text(
                            'Instructions',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            Instruction instruction = RecipePreviewViewModel.getInstructionsWithNotes(recipe)[index];
                            return ListTile(
                              title: Text(instruction.text ?? ''),
                              subtitle: Text(instruction.note?.text ?? ''),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  Instruction updatedInstruction = instruction.copyWithNoNote();

                                  model.updateInstruction(updatedInstruction, recipe);

                                  router.pop(context);
                                },
                              ),
                            );
                          },
                          childCount: RecipePreviewViewModel.getInstructionsWithNotes(recipe).length,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
      label: Text('Notes'),
      icon: Icon(Icons.sticky_note_2_outlined),
    );
  }
}
