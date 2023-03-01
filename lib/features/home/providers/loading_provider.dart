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
