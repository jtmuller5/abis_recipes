// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../features/books/services/book_service.dart' as _i4;
import '../features/books/services/current_recipe_service.dart' as _i6;
import '../features/books/services/firestore_book_service.dart' as _i5;
import '../features/books/ui/recipe_page/recipe_view_model.dart' as _i7;
import '../features/home/services/app_service.dart' as _i3;
import '../features/home/services/search_service.dart' as _i9;
import '../features/recipes/services/recipes_service.dart' as _i8;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.singleton<_i3.AppService>(_i3.AppService());
  gh.lazySingleton<_i4.BookService>(() => _i5.FirestoreBookService());
  gh.lazySingleton<_i6.CurrentRecipeService>(() => _i6.CurrentRecipeService());
  gh.lazySingleton<_i7.RecipeViewModel>(() => _i7.RecipeViewModel());
  gh.lazySingleton<_i8.RecipesService>(() => _i8.RecipesService());
  gh.lazySingleton<_i9.SearchService>(() => _i9.SearchService());
  return getIt;
}
