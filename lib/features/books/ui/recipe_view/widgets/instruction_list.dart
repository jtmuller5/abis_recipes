import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/features/books/models/gpt_message.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/note.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/services/chat_gpt_service.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/recipe_view_model.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InstructionList extends StatelessWidget {
  InstructionList({
    Key? key, required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          Instruction instruction = (recipe.instructions ?? [])[index];

          return InstructionTile(
            instruction,
            index,
            recipe: recipe,
          );
        },
        childCount: (recipe.instructions ?? []).length,
      ),
    );
  }
}

class InstructionTile extends StatefulWidget {
  const InstructionTile(
      this.instruction,
      this.index, {
        Key? key, required this.recipe,
      }) : super(key: key);

  final Recipe recipe;
  final Instruction instruction;
  final int index;

  @override
  State createState() => _InstructionTileState();
}

class _InstructionTileState extends State<InstructionTile> {
  bool showShort = false;
  bool shortening = false;

  @override
  Widget build(BuildContext context) {

    RecipeViewModel model = getModel<RecipeViewModel>(context);

    return Animate(
      effects: [
        ScaleEffect(delay: Duration(milliseconds: 50 * widget.index)),
        FadeEffect(delay: Duration(milliseconds: 10 * widget.index)),
      ],
      child: Builder(
        builder: (context) {
          return InkWell(
            onTap: () async {
              if (widget.instruction.shortened ?? false) {
                setState(() {
                  showShort = !showShort;
                });
              } else {
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
                      Offset.zero & overlay.size ,
                    ),
                    items: [
                      const PopupMenuItem(value: 'note', child: Text('Add Note')),
                      const PopupMenuItem(value: 'shorten', child: Text('Shorten')),
                    ],
                  );
                  if (value != null) {
                    if (value == 'shorten') {

                      if (!(widget.instruction.shortened ?? false) && (widget.instruction.text ?? '').length > 80) {
                        setState(() {
                          shortening = true;
                        });
                        GptMessage message = await ChatGptService.shortenContent(widget.instruction.text!);

                        Instruction newInstruction = widget.instruction.copyWith(
                          shortText: message.choices.first.message.content.trim().replaceAll('"', ''),
                          shortened: true,
                        );

                        model.updateInstruction(newInstruction, widget.recipe);

                        setState(() {
                          shortening = false;
                          showShort = true;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Instruction cannot be shortened'),
                        ));
                      }
                    } else if (value == 'note') {
                      final noteText = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {

                          TextEditingController noteController = TextEditingController();
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.transparent,
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
                          recipeId: widget.recipe.recipeId,
                          createdAt: DateTime.now(),
                        );

                        await model.updateInstruction(widget.instruction.copyWith(note: note), widget.recipe);
                      }
                    }
                  }
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8),
                    child: SizedBox(
                      width: 40,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: shortening ? CircularProgressIndicator(color: Colors.white,):Center(
                              child: Text('${widget.index + 1}',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                            ),
                          ),
                          if (widget.instruction.note != null)
                            IconButton(
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
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.transparent,
                                    title: Text('Note'),
                                    content: Text(widget.instruction.note!.text ?? ''),
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
                            ),
                          if(widget.instruction.shortened ?? false)
                            IconButton(
                              constraints: BoxConstraints.tightFor(width: 40, height: 40),
                              icon: Icon(
                                showShort ? Icons.expand: Icons.compress,
                                color: Theme.of(context).colorScheme.primary,

                              ),
                              onPressed: (){
                                setState(() {
                                  showShort = !showShort;
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(showShort ? widget.instruction.shortText ?? '' : widget.instruction.text ?? '',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/*SelectableText(
            showShort ? widget.instruction.shortText ?? '' : widget.instruction.text ?? '',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
            contextMenuBuilder: (context, editableTextState) {
              return AdaptiveTextSelectionToolbar(
                  anchors: editableTextState.contextMenuAnchors,
                  children: [
                    InkWell(
                      onTap: (){},
                      child: SizedBox(
                        width: 200.0,
                        child: Text('Note'),
                      ),
                    )
                  ]);
            },
          ),*/

