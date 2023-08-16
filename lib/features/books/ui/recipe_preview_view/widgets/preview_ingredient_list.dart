import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class PreviewIngredientList extends StatelessWidget with GetItMixin {
   PreviewIngredientList({
    Key? key, required this.recipe,
  }) : super(key: key);

   final Recipe recipe;

  @override
  Widget build(BuildContext context) {

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
