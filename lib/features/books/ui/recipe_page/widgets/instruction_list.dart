import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/gpt_message.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/note.dart';
import 'package:abis_recipes/features/books/services/chat_gpt_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InstructionList extends StatelessWidget {
  const InstructionList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          Instruction instruction = (currentRecipeService.recipe.value?.instructions ?? [])[index];

          return InstructionTile(
            instruction,
            index,
          );
        },
        childCount: (currentRecipeService.recipe.value?.instructions ?? []).length,
      ),
    );
  }
}

class InstructionTile extends StatefulWidget {
  const InstructionTile(
      this.instruction,
      this.index, {
        Key? key,
      }) : super(key: key);

  final Instruction instruction;
  final int index;

  @override
  State createState() => _InstructionTileState();
}

class _InstructionTileState extends State<InstructionTile> {
  bool showShort = false;

  @override
  Widget build(BuildContext context) {
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
                        GptMessage message = await ChatGptService.shortenContent(widget.instruction.text!);

                        Instruction newInstruction = widget.instruction.copyWith(
                          shortText: message.choices.first.message.content.trim().replaceAll('"', ''),
                          shortened: true,
                        );

                        currentRecipeService.updateInstruction(newInstruction);

                        setState(() {
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
                          recipeId: currentRecipeService.recipe.value!.recipeId,
                          createdAt: DateTime.now(),
                        );

                        await currentRecipeService.updateInstruction(widget.instruction.copyWith(note: note));
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
                            child: Center(
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
                                    title: Text('Note'),
                                    content: Text(widget.instruction.note!.text ?? ''),
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
                            ) else SizedBox(height: 40,width: 40,),
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

