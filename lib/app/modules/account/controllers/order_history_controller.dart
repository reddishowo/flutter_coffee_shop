import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth_service.dart';

class OrderHistoryController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Observable list untuk menampung data order
  var orders = <QueryDocumentSnapshot>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyOrders();
  }

  void fetchMyOrders() {
    final user = AuthService.to.firebaseUser.value;
    
    // Jika user belum login, stop loading
    if (user == null) {
      isLoading.value = false;
      return;
    }

    // Query ke Firestore:
    // 1. Collection 'orders'
    // 2. Filter: hanya userId milik user yang login
    // 3. Sort: dari yang terbaru (createdAt descending)
    _db.collection('orders')
       .where('userId', isEqualTo: user.uid)
       .orderBy('createdAt', descending: true)
       .snapshots()
       .listen((snapshot) {
         orders.value = snapshot.docs;
         isLoading.value = false;
       }, onError: (e) {
         print("Error fetching orders: $e");
         isLoading.value = false;
       });
  }
}