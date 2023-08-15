import 'package:abis_recipes/app/get_it.dart';
import 'package:abis_recipes/features/books/services/book_service.dart';
import 'package:abis_recipes/features/books/services/current_recipe_service.dart';
import 'package:abis_recipes/features/home/services/app_service.dart';
import 'package:abis_recipes/features/home/services/search_service.dart';
import 'package:abis_recipes/features/recipes/services/recipes_service.dart';
import 'package:abis_recipes/features/shared/services/database_service.dart';

AppService get appService => getIt.get<AppService>();
BookService get bookService => getIt.get<BookService>();
DatabaseService get databaseService => getIt.get<DatabaseService>();
CurrentRecipeService get currentRecipeService => getIt.get<CurrentRecipeService>();
RecipesService get recipesService => getIt.get<RecipesService>();
SearchService get searchService => getIt.get<SearchService>();