import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/gpt_message.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/note.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/services/chat_gpt_service.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/recipe_preview_view_model.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PreviewInstructionList extends StatelessWidget {
  PreviewInstructionList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipePreviewViewModel model = getModel<RecipePreviewViewModel>(context);
    Recipe? recipe = model.recipe.value;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Instruction instruction = (recipe?.instructions ?? [])[index];

          return InstructionTile(
            recipe!,
            instruction,
            index,
          );
        },
        childCount: (recipe?.instructions ?? []).length,
      ),
    );
  }
}

class InstructionTile extends StatefulWidget {
  const InstructionTile(
    this.recipe,
    this.instruction,
    this.index, {
    Key? key,
  }) : super(key: key);

  final Recipe recipe;
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
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
                            child: Text('${widget.index + 1}', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(showShort ? widget.instruction.shortText ?? '' : widget.instruction.text ?? '', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
