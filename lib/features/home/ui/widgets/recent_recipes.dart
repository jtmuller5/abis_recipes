import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/shared/ui/pastry_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

class RecentRecipes extends StatelessWidget {
  const RecentRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Recipe>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('recipes')
      .orderBy('createdAt', descending: true)
          .snapshots()
          .map((event) => event.docs.map((e) => Recipe.fromJson(e.data())).toList()),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Recent Recipes', style: Theme.of(context).textTheme.titleMedium),
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Recipe recipe = snapshot.data![index];
                  return Card(
                    color: Colors.white,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: (){
                            context.push('/recipe/${recipe.recipeId}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(recipe.images?.firstOrNull != null )SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(recipe.images!.firstOrNull!, fit: BoxFit.cover,))),
                                gap8,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(recipe.title ?? '', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                                      Text(recipe.url ?? '',maxLines: 1,),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )

                   /* ListTile(
                      title: Text(recipe.title ?? ''),
                      subtitle: Text(recipe.url ?? ''),
                    ),*/
                  );
                },
              ),
            ],
          );
        } else if(snapshot.data?.isEmpty ?? false){
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PastryIcon(pastry: Pastry.eclair, asset: 'assets/pin.png',
                sideLength: 200,),
                Text('No recipes yet'),
                gap64
              ],
            ),
          );
        }else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
