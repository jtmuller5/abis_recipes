import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IngredientsNotifier extends StateNotifier<List<Ingredient>> {
  IngredientsNotifier() : super([]);

  void addIngredient(Ingredient ingredient) {
     // Add if not already in list
    if (!state.where((element) => element.name == ingredient.name).isNotEmpty) {
      state = [...state, ingredient];
    }
  }

  void removeIngredient(Ingredient ingredient) => state = [...state]..remove(ingredient);

  void clearIngredients() => state = [];
}

final ingredientsProvider = StateNotifierProvider<IngredientsNotifier, List<Ingredient>>((ref) {
  return IngredientsNotifier();
});