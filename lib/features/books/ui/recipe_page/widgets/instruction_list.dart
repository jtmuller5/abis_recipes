import 'package:abis_recipes/features/books/models/gpt_message.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/services/chat_gpt_service.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InstructionList extends ConsumerWidget {
  const InstructionList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Instruction instruction = (ref.watch(recipeProvider)?.instructions ?? [])[index];

          return InstructionTile(
            instruction,
            index,
          );
        },
        childCount: (ref.watch(recipeProvider)?.instructions ?? []).length,
      ),
    );
  }
}

class InstructionTile extends ConsumerStatefulWidget {
  const InstructionTile(
    this.instruction,
    this.index, {
    Key? key,
  }) : super(key: key);

  final Instruction instruction;
  final int index;

  @override
  ConsumerState createState() => _InstructionTileState();
}

class _InstructionTileState extends ConsumerState<InstructionTile> {

  bool showShort = false;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        ScaleEffect(delay: Duration(milliseconds: 50 * widget.index)),
        FadeEffect(delay: Duration(milliseconds: 10 * widget.index)),
      ],
      child: Builder(builder: (context) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          minLeadingWidth: 0,
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
                    rect,
                    Offset.zero & overlay.size,
                  ),
                  items: [
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

                      ref.read(recipeProvider.notifier).updateInstruction(newInstruction);

                      setState(() {
                        showShort = true;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Instruction cannot be shortened'),
                      ));
                    }
                  }
                }
              }
            }
          },
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Center(
              child: Text('${widget.index + 1}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ),
          title: Text(
           showShort? widget.instruction.shortText ?? '' : widget.instruction.text ?? '',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
          ),
        );
      }),
    );
  }
}
