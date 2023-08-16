import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/note.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/recipe_view_model.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IngredientList extends StatelessWidget  {
   IngredientList({
    Key? key, required this.recipe,
  }) : super(key: key);

   final Recipe recipe;

  @override
  Widget build(BuildContext context) {

    RecipeViewModel model = getModel<RecipeViewModel>(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Ingredient? ingredient = recipe.ingredients?[index];
          return Animate(
            effects: [
              ScaleEffect(delay: Duration(milliseconds: 50 * index)),
              FadeEffect(delay: Duration(milliseconds: 10 * index)),
            ],
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    return ListTile(
                      title: Text(
                        ingredient?.name ?? '',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                      ),
                      trailing:ingredient?.note != null ? IconButton(
                        constraints: BoxConstraints.tightFor(width: 40, height: 40),
                        icon: Icon(
                          Icons.sticky_note_2_outlined,
                          color: Theme.of(context).colorScheme.primary,

                        ),
                        onPressed: (){
                          // Display note
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Note'),
                              content: Text(ingredient?.note!.text ?? ''),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    router.pop();
                                  },
                                  child: Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                      ): null,
                      onTap: () async {
                        Rect? rect;
                        RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                        final renderObject = context.findRenderObject();
                        final translation = renderObject?.getTransformTo(null).getTranslation();
                        if (translation != null && renderObject?.paintBounds != null) {
                          final offset = Offset(translation.x, translation.y);
                          rect = renderObject!.paintBounds.shift(offset);
                        }
                        if (rect != null) {
                          var value = await showMenu<String>(
                            context: context,
                            position: RelativeRect.fromRect(
                              rect.translate(rect.width, 0),
                              Offset.zero & overlay.size,
                            ),
                            items: [
                              const PopupMenuItem(value: 'note', child: Text('Note')),
                            ],
                          );
                          if (value != null) {
                            debugPrint(value);
                            if(value == 'note'){

                              final noteText = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController noteController = TextEditingController();
                                  return AlertDialog(
                                    title: Text('New Note'),
                                    content: TextField(
                                      controller: noteController,
                                      autofocus: true,
                                      decoration: InputDecoration(hintText: 'Enter your note here'),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () => router.pop(),
                                      ),
                                      TextButton(
                                        child: Text('Save'),
                                        onPressed: () => router.pop(noteController.text),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (noteText != null && noteText.isNotEmpty) {
                                Note note = Note(
                                  text: noteText,
                                  recipeId: recipe.recipeId,
                                  createdAt: DateTime.now(),
                                );

                                await model.updateIngredient(ingredient!.copyWith(note: note), recipe);
                              }
                            }
                          }
                        }

                      },
                    );
                  }
                ),
                // Divider
                if (index != (recipe.ingredients ?? []).length - 1)
                  Divider(
                    height: 4,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
              ],
            ),
          );
        },
        childCount: (recipe.ingredients ?? []).length,
      ),
    );
  }
}
