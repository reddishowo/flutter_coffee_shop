import 'package:get/get.dart';

class SearchController extends GetxController {
  final query = ''.obs;

  void setQuery(String val) {
    query.value = val;
  }
}
