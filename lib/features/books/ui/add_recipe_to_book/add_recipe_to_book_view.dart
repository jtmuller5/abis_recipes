import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/shared/ui/pastry_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_recipe_to_book_view_model.dart';

class AddRecipeToBookView extends StatelessWidget {
  const AddRecipeToBookView({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return AddRecipeToBookViewModelBuilder(
        builder: (context, model) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add Recipe to Book'),
            ),
            body:StreamBuilder<List<Book>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('books')
                    .snapshots()
                    .map((event) => event.docs.map((e) => Book.fromJson(e.data())).toList()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading books'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Book book = snapshot.data![index];

                      return Row(
                        children: [
                          PastryIcon(pastry: book.pastry),
                          Expanded(
                            child: CheckboxListTile(

                              title: Text(
                                book.title,
                              ),
                              value: bookService.checkedBooks.value.contains(book.bookId),
                              onChanged: (value) {
                                if(value ?? false){
                                  model.addCheckedBook(book.bookId);
                                } else {
                                  model.removeCheckedBook(book.bookId);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                  Recipe newRecipe = Recipe(
                    coverImage: null,
                    description: null,
                    bookIds: bookService.checkedBooks.value,
                    title: recipe.title,
                    images: recipe.images != null ? recipe.images! : [],
                    ingredients: recipe.ingredients?.map((e) => Ingredient(name: e.name)).toList(),
                    instructions: recipe.instructions?.map((e) => Instruction(text: e.text)).toList(),
                    url: recipe.url,
                    recipeId: recipe.recipeId,
                    createdAt: recipe.createdAt ?? DateTime.now(),
                  );

                  bookService.checkedBooks.value.forEach((bookId) {
                    bookService.addRecipeToBook(newRecipe, bookId);
                  });

                  model.updateRecipe(newRecipe);

                router.pop();
              },
              child: Icon(Icons.check),
            ),
          );
        },
      );
  }
}