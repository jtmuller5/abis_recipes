import 'package:abis_recipes/features/books/models/ingredient.dart';
import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:abis_recipes/features/books/models/note.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';

class RecipeService{
  static List<Note> getAllNotes(Recipe recipe){

    List<Note> notes = [];

    recipe.ingredients?.forEach((ingredient) {
      if(ingredient.note != null){
        notes.add(ingredient.note!);
      }
    });

    recipe.instructions?.forEach((instruction) {
      if(instruction.note != null){
        notes.add(instruction.note!);
      }
    });

    return notes;
  }

  static List<Ingredient> getIngredientsWithNotes(Recipe recipe){
    List<Ingredient> ingredients = [];

    recipe.ingredients?.forEach((ingredient) {
      if(ingredient.note != null){
        ingredients.add(ingredient);
      }
    });

    return ingredients;
  }

  static List<Instruction> getInstructionsWithNotes(Recipe recipe){
    List<Instruction> instructions = [];

    recipe.instructions?.forEach((instruction) {
      if(instruction.note != null){
        instructions.add(instruction);
      }
    });

    return instructions;
  }
}