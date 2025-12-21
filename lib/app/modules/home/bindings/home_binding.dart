import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../../../controllers/product_controller.dart'; 

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<SearchController>(() => SearchController());
    
    // Inisialisasi ProductController disini agar data langsung load saat Home dibuka
    Get.put(ProductController(), permanent: true); 
  }
}