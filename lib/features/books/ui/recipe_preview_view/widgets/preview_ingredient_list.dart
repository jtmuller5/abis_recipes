import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class PreviewIngredientList extends StatelessWidget with GetItMixin {
   PreviewIngredientList({
    Key? key, required this.ingredients,
  }) : super(key: key);

   final List<String> ingredients;

  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          String? ingredient = ingredients[index];
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
                        ingredient ?? '',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                      ),
                    );
                  }
                ),
                // Divider
                if (index != ingredients.length - 1)
                  Divider(
                    height: 4,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
              ],
            ),
          );
        },
        childCount: ingredients.length,
      ),
    );
  }
}
