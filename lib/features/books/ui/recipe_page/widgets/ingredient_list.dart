import 'package:abis_recipes/features/books/models/ingredient.dart';
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
                ListTile(
                  title: Text(
                    ingredient?.name ?? '',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                  ),
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
