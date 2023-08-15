import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SearchService {
  ValueNotifier<String?> search = ValueNotifier(null);

  ValueNotifier<String?> url = ValueNotifier(null);

  void setUrl(String? val){
    url.value = val;
  }

  void setSearch(String? val) {
    search.value = val;
  }
}
