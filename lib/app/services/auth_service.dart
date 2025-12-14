// File: /lib/app/services/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

class AuthService extends GetxController {
  static AuthService get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Observable User
  late Rx<User?> firebaseUser;
  
  // User Data from Firestore
  var userData = <String, dynamic>{}.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    
    // Listen to user changes to handle routing
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(Routes.WELCOME);
    } else {
      fetchUserData();
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> fetchUserData() async {
    if (_auth.currentUser != null) {
      try {
        DocumentSnapshot doc = await _db.collection('users').doc(_auth.currentUser!.uid).get();
        if (doc.exists) {
          userData.value = doc.data() as Map<String, dynamic>;
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  // Sign Up
  Future<void> register(String name, String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create User in Firestore
      await _db.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'phone': '',
        'photoUrl': 'https://i.pravatar.cc/150?img=5', // Default image
        'createdAt': DateTime.now(),
      });
      
      await cred.user!.updateDisplayName(name);
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Unknown error", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Update Profile
  Future<void> updateProfile(String name, String phone) async {
    try {
      String uid = _auth.currentUser!.uid;
      
      await _db.collection('users').doc(uid).update({
        'name': name,
        'phone': phone,
      });

      // Update local observable immediately
      userData['name'] = name;
      userData['phone'] = phone;
      userData.refresh(); // Ensure UI updates
      
      Get.snackbar("Success", "Profile updated!", backgroundColor: Get.theme.primaryColor, colorText: Get.theme.canvasColor);
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}