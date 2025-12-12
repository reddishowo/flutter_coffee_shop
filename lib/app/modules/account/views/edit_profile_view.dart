import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';

// Controller
class EditProfileController extends GetxController {
  final nameController = TextEditingController(text: "Salsa");
  final emailController = TextEditingController(text: "salsa@gmail.com");
  final phoneController = TextEditingController(text: "0812345678");
  var isLoading = false.obs;

  void saveProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.back();
    Get.snackbar("Success", "Profile updated successfully!", backgroundColor: Colors.green, colorText: Colors.white);
  }
}

// View
class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(title: const Text("Edit Profile"), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
            ),
            const SizedBox(height: 30),
            _buildTextField("Full Name", controller.nameController, Icons.person),
            const SizedBox(height: 20),
            _buildTextField("Email", controller.emailController, Icons.email),
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