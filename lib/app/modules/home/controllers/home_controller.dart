import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeController extends GetxController {
  int index = 0;
  
  @override
  void onInit() {
    super.onInit();
    _printToken();
  }

  void _printToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("========================================");
    print("FCM DEVICE TOKEN (Copy this to Firebase Console):");
    print(token);
    print("========================================");
  }

  void changeIndex(int i) {
    index = i;
    update();
  }
}