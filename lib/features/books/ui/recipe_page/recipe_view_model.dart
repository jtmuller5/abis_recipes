import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RecipeViewModel extends ChangeNotifier {
  ValueNotifier<bool> loading = ValueNotifier(false);

  bool get isLoading => loading.value;

  void setLoading(bool val) {
    loading.value = val;
    notifyListeners();
  }
}