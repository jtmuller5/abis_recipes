import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController searchController = useTextEditingController();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text('Search')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  ref.watch(searchProvider.notifier).state = value;
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Recipe recipe = ref.watch(recipesProvider)[index];
                return ListTile(
                  leading: SizedBox(
                      height: 64,
                      width: 64,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: recipe.images?.firstOrNull != null
                            ? FadeInImage(
                                placeholder: AssetImage('assets/transparent.png'),
                                image: NetworkImage(recipe.images!.first),
                                fit: BoxFit.cover,
                              )
                            : ColoredBox(color: Theme.of(context).colorScheme.secondary, child: Icon(Icons.book)),
                      )),
                  title: Text(recipe.title ?? ''),
                  subtitle: Text(''),
                  onTap: () {
                    RecipeNotifier.navigateToRecipe(recipe, ref, context);
                  },
                );
              },
              childCount: ref.watch(recipesProvider).length,
            ),
          ),
        ],
      ),
    );
  }
}
