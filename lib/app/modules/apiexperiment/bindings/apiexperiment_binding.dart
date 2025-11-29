import 'package:get/get.dart';

import '../controllers/apiexperiment_controller.dart';

class ApiexperimentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiexperimentController>(
      () => ApiexperimentController(),
    );
  }
}
