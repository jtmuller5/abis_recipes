import 'package:hooks_riverpod/hooks_riverpod.dart';

final urlProvider = StateProvider<String?>((ref) {
  return null;
});

final loadingRecipeProvider = StateProvider<bool>((ref) {
  return false;
});

final errorProvider = StateProvider<bool>((ref) {
  return false;
});

class bakeModeNotifier extends StateNotifier<bool> {
  bakeModeNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final bakeModeProvider = StateNotifierProvider<bakeModeNotifier, bool>((ref) {
  return bakeModeNotifier();
});

