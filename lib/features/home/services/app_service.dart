import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class AppService {

  ValueNotifier<bool> bakeMode = ValueNotifier(false);

  void setBakeMode(bool val) {
    bakeMode.value = val;
  }
}
