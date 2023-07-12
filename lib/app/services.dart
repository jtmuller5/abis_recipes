import 'package:abis_recipes/app/get_it.dart';
import 'package:abis_recipes/features/books/services/book_service.dart';
import 'package:abis_recipes/features/recipes/services/recipes_service.dart';
import 'package:abis_recipes/features/shared/services/database_service.dart';

BookService get bookService => getIt.get<BookService>();
DatabaseService get databaseService => getIt.get<DatabaseService>();
RecipesService get recipesService => getIt.get<RecipesService>();