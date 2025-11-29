import 'package:coffee_shop/app/modules/apiexperiment/controllers/apiexperiment_controller.dart';
import 'package:coffee_shop/app/modules/cart/controllers/cart_controller.dart';
import 'package:coffee_shop/app/modules/search/controllers/search_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CartController>(
      () => CartController(),
    );
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
    Get.lazyPut<ApiexperimentController>(
      () => ApiexperimentController(),
    );
  }
}
