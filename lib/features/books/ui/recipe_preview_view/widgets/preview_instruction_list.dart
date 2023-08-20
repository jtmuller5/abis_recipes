import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PreviewInstructionList extends StatelessWidget {
  PreviewInstructionList({
    Key? key, required this.instructions,
  }) : super(key: key);

  final List<String> instructions;

  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          String instruction = instructions[index];

          return Animate(
            effects: [
              ScaleEffect(delay: Duration(milliseconds: 50 * index)),
              FadeEffect(delay: Duration(milliseconds: 10 * index)),
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
                                  child: Text('${index + 1}', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
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
                        child: Text(instruction, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        childCount: instructions.length,
      ),
    );
  }
}