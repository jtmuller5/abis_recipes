import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/services/current_recipe_service.dart';
import 'package:flutter/material.dart';

class NotesButton extends StatelessWidget {
  const NotesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: appService.hasError,
        builder: (context, error, child) {
          return Container(
            child: error
                ? null
                : FloatingActionButton.extended(
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
                            if (CurrentRecipeService.getIngredientsWithNotes(currentRecipeService.recipe.value!).isNotEmpty) ...[
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
                                    Ingredient ingredient = CurrentRecipeService.getIngredientsWithNotes(currentRecipeService.recipe.value!)[index];
                                    return ListTile(
                                      title: Text(ingredient.name ?? ''),
                                      subtitle: Text(ingredient.note?.text ?? ''),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          Ingredient updatedIngredient = ingredient.copyWithNoNote();

                                          currentRecipeService.updateIngredient(updatedIngredient);

                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                  childCount: CurrentRecipeService.getIngredientsWithNotes(currentRecipeService.recipe.value!).length,
                                ),
                              )
                            ],
                            if (CurrentRecipeService.getInstructionsWithNotes(currentRecipeService.recipe.value!).isNotEmpty) ...[
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
                                    Instruction instruction = CurrentRecipeService.getInstructionsWithNotes(currentRecipeService.recipe.value!)[index];
                                    return ListTile(
                                      title: Text(instruction.text ?? ''),
                                      subtitle: Text(instruction.note?.text ?? ''),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          Instruction updatedInstruction = instruction.copyWithNoNote();

                                          currentRecipeService.updateInstruction(updatedInstruction);

                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                  childCount: CurrentRecipeService.getInstructionsWithNotes(currentRecipeService.recipe.value!).length,
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
            ),
          );
        });
  }
}
