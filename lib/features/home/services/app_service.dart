import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class AppService {
  ValueNotifier<String?> currentUrl = ValueNotifier(null);

  void setCurrentUrl(String? val) {
    currentUrl.value = val;
  }

  ValueNotifier<bool> loadingRecipe = ValueNotifier(false);

  void setLoadingRecipe(bool val) {
    loadingRecipe.value = val;
  }

  ValueNotifier<bool> hasError = ValueNotifier(false);

  void setHasError(bool val) {
    hasError.value = val;
  }

  ValueNotifier<bool> bakeMode = ValueNotifier(false);

  void setBakeMode(bool val) {
    bakeMode.value = val;
  }
}
