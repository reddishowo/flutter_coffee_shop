import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../services/auth_service.dart';

// Controller
class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load current data
    final user = AuthService.to.userData;
    nameController.text = user['name'] ?? '';
    phoneController.text = user['phone'] ?? '';
  }

  void saveProfile() async {
    isLoading.value = true;
    await AuthService.to.updateProfile(
      nameController.text.trim(),
      phoneController.text.trim(),
    );
    isLoading.value = false;
    Get.back(); // Go back to Account Page
  }
}

// View
class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    final user = AuthService.to.userData;

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(title: const Text("Edit Profile"), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() => CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user['photoUrl'] ?? 'https://i.pravatar.cc/150?img=5'),
            )),
            const SizedBox(height: 10),
            const Text("Change Profile Picture (Coming Soon)", style: TextStyle(fontSize: 12, color: Colors.grey)),
            
            const SizedBox(height: 30),
            _buildTextField("Full Name", controller.nameController, Icons.person),
            const SizedBox(height: 20),
            // Note: Email is usually read-only in simple edits unless re-authenticated
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
              child: Text("Email: ${user['email']}", style: TextStyle(color: Colors.grey[600])),
            ),
            const SizedBox(height: 20),
            _buildTextField("Phone", controller.phoneController, Icons.phone),
            const SizedBox(height: 40),
            
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brownDark,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: controller.isLoading.value 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("Save Changes"),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.brownDark),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}