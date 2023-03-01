import 'package:abis_recipes/features/books/models/instruction.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InstructionsNotifier extends StateNotifier<List<Instruction>> {
  InstructionsNotifier() : super([]);

  void addInstruction(Instruction instruction) => state = [...state, instruction];

  void removeInstruction(Instruction instruction) => state = [...state]..remove(instruction);

  void clearInstructions() => state = [];

  void setInstructions(List<Instruction> instructions) => state = instructions;
}

final instructionsProvider = StateNotifierProvider<InstructionsNotifier, List<Instruction>>((ref) {
  return InstructionsNotifier();
});