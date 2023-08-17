import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/add_recipe_to_book/add_recipe_to_book_view.dart';
import 'package:abis_recipes/features/books/ui/book_view/book_view.dart';
import 'package:abis_recipes/features/books/ui/books_view/books_view.dart';
import 'package:abis_recipes/features/books/ui/new_book/new_book_view.dart';
import 'package:abis_recipes/features/books/ui/recipe_preview_view/recipe_preview_view.dart';
import 'package:abis_recipes/features/books/ui/recipe_view/recipe_view.dart';
import 'package:abis_recipes/features/books/ui/search/ui/search_view.dart';
import 'package:abis_recipes/features/home/ui/home_view.dart';
import 'package:abis_recipes/features/shared/ui/app_name.dart';
import 'package:abis_recipes/features/shared/ui/browser/browser_view.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final providers = [EmailAuthProvider()];

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeView(),
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser == null) {
          return '/sign-in';
        } else {
          return '/';
        }
      },
    ),
    GoRoute(
        path: '/sign-in',
        builder: (context, state) => SignInScreen(
              providers: providers,
              headerBuilder: (context, constraints, shrinkOffset) {
                return SizedBox(
                  height: 200,
                  child: AppName(),
                );
              },
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  context.pushReplacementNamed('/');
                }),
              ],
            )),
    GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen(
              providers: providers,
              appBar: AppBar(
                title: Text('Account'),
              ),
              actions: [
                SignedOutAction((context) {
                  context.pushReplacementNamed('/sign-in');
                }),
              ],
            )),
    GoRoute(
      path: '/browser',
      builder: (context, state) {
        return BrowserView(url: state.uri.queryParameters['url']!);
      },
    ),
    GoRoute(
      path: '/books',
      builder: (context, state) {
        return BooksView();
      },
    ),
    GoRoute(
      path: '/book/:id',
      builder: (context, state) {
        return BookView(bookId: state.pathParameters['id']!,);
      },
    ),
    GoRoute(
      path: '/new-book',
      builder: (context, state) {
        return NewBookView();
      },
    ),
    GoRoute(
      path: '/add-recipe-to-book',
      builder: (context, state) {
        return AddRecipeToBookView(recipe: state.extra as Recipe);
      },
    ),
    GoRoute(
      path: '/recipes',
      builder: (context, state) {
        return SearchView();
      },
    ),
    GoRoute(
      path: '/recipe-preview',
      builder: (context, state) {
        return RecipePreviewView(url: state.uri.queryParameters['url']!);
      },
    ),
    GoRoute(
      path: '/recipe/:id',
      builder: (context, state) {
        return RecipeView(id: state.pathParameters['id']!);
      },
    ),
  ],
);
