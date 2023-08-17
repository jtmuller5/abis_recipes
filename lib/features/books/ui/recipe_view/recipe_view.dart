import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/widgets/ingredient_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/widgets/instruction_list.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/widgets/notes_button.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/widgets/recipe_header.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/recipe_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecipeView extends StatelessWidget {
  RecipeView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return RecipeViewModelBuilder(
      builder: (context, model) {
        return StreamBuilder<Recipe>(
              stream:
                  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').doc(id).snapshots().map((event) => Recipe.fromJson(event.data()!)),
              builder: (context, snapshot) {
                return Scaffold(
                  body: Builder(
                    builder:(context) {
                      if (snapshot.hasError || model.deleting) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ));
                      }

                      Recipe? recipe = snapshot.data;
                      return Stack(
                        children: [
                          Animate(
                            effects: [FadeEffect()],
                            child: CustomScrollView(slivers: [
                              SliverAppBar(
                                leading: BackButton(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                elevation: 0,
                                backgroundColor: Theme.of(context).colorScheme.background,
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                       router.push(Uri(path: '/add-recipe-to-book').toString(),extra: recipe);
                                      },
                                      icon: Icon(Icons.book)),
                                  Builder(builder: (context) {
                                    return IconButton(
                                        onPressed: () async {
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
                                                const PopupMenuItem(value: 'delete', child: Text('Delete Recipe')),
                                              ],
                                            );
                                            if (value != null) {
                                              debugPrint(value);
                                              if (value == 'delete') {
                                                if (recipe != null) {
                                                  await model.deleteRecipe(recipe.recipeId);
                                                  router.pop();
                                                }
                                                router.pop();
                                              }
                                            }
                                          }
                                        },
                                        icon: Icon(Icons.more_vert));
                                  })
                                ],
                              ),
                              if (recipe?.title != null && recipe?.images != null)
                                SliverToBoxAdapter(
                                  child: RecipeHeader(
                                    recipe?.title ?? '',
                                    recipe?.images?.firstOrNull ?? '',
                                    recipe?.url ?? '',
                                  ),
                                ),
                              SliverToBoxAdapter(child: Divider()),
                              if ((recipe?.ingredients ?? []).isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Ingredients',
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              if (recipe != null) IngredientList(recipe: recipe),
                              SliverToBoxAdapter(child: Divider()),
                              if ((recipe?.instructions ?? []).isNotEmpty)
                                SliverToBoxAdapter(
                                  child: ListTile(
                                    title: Text(
                                      'Directions',
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text('${recipe?.instructions!.length} steps'),
                                  ),
                                ),
                              if(snapshot.data != null )InstructionList(recipe: snapshot.data!),
                              SliverToBoxAdapter(child: gap64),
                            ]),
                          ),
                        ],
                      );
                    },
                  ),
                  floatingActionButton: (snapshot.hasData && snapshot.data != null)?  NotesButton(recipe: snapshot.data): null,
                );

              }

        );
      },
    );
  }
}
