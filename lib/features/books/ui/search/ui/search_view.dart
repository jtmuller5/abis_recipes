import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/recipe_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text('All Recipes')),
          /*SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  searchService.setSearch(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),*/
          //https://addapinch.com/the-best-chocolate-cake-recipe-ever/
          StreamBuilder<List<Recipe>>(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('recipes').snapshots().map((event) {
                return event.docs.map((e) => Recipe.fromJson(e.data())).toList();
              }),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(child: Text(snapshot.error.toString()));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return SliverToBoxAdapter(child: Text('No data'));
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Recipe recipe = snapshot.data![index];
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
                          RecipeViewModel.navigateToRecipe(recipe, context);
                        },
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
