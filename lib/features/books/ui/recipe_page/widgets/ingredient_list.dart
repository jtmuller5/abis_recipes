import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/note.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IngredientList extends ConsumerWidget {
  const IngredientList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Ingredient? ingredient = ref.watch(recipeProvider)?.ingredients?[index];
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
                                    Navigator.of(context).pop();
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
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                      TextButton(
                                        child: Text('Save'),
                                        onPressed: () => Navigator.of(context).pop(noteController.text),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (noteText != null && noteText.isNotEmpty) {
                                Note note = Note(
                                  text: noteText,
                                  recipeId: ref.watch(recipeProvider)!.id,
                                  createdAt: DateTime.now(),
                                );

                                await ref.read(recipeProvider.notifier).updateIngredient(ingredient!.copyWith(note: note));
                              }
                            }
                          }
                        }

                      },
                    );
                  }
                ),
                // Divider
                if (index != (ref.watch(recipeProvider)?.ingredients ?? []).length - 1)
                  Divider(
                    height: 4,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
              ],
            ),
          );
        },
        childCount: (ref.watch(recipeProvider)?.ingredients ?? []).length,
      ),
    );
  }
}
