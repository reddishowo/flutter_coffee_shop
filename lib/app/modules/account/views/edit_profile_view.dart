import 'dart:io'; // Import File
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Import Image Picker
import '../../../theme/app_theme.dart';
import '../../../services/auth_service.dart';

// Update Controller
class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = AuthService.to.userData;
    nameController.text = user['name'] ?? '';
    phoneController.text = user['phone'] ?? '';
  }

  // --- FUNGSI PILIH GAMBAR DARI GALERI ---
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pilih gambar dari galeri
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // Simpan path ke Local Storage via AuthService
      await AuthService.to.updateLocalProfileImage(image.path);
      Get.snackbar("Sukses", "Foto profil berhasil diganti (Lokal)");
    }
  }

  void saveProfile() async {
    isLoading.value = true;
    await AuthService.to.updateProfile(
      nameController.text.trim(),
      phoneController.text.trim(),
    );
    isLoading.value = false;
    Get.back();
  }
}

// Update View
class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    final auth = AuthService.to; // Akses Auth Service

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(title: const Text("Edit Profile"), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- BAGIAN FOTO PROFIL ---
            GestureDetector(
              onTap: controller.pickImage, // Klik untuk ganti foto
              child: Stack(
                children: [
                  Obx(() {
                    // Logika: Cek Lokal dulu, kalau kosong baru cek Firebase, kalau kosong pake default
                    String localPath = auth.localProfilePath.value;
                    String? netUrl = auth.userData['photoUrl'];

                    ImageProvider imageProvider;
                    
                    if (localPath.isNotEmpty && File(localPath).existsSync()) {
                      // 1. Pakai File Lokal
                      imageProvider = FileImage(File(localPath));
                    } else if (netUrl != null && netUrl.isNotEmpty) {
                      // 2. Pakai URL Firebase
                      imageProvider = NetworkImage(netUrl);
                    } else {
                      // 3. Default
                      imageProvider = const NetworkImage('https://i.pravatar.cc/150?img=5');
                    }

                    return CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: imageProvider,
                    );
                  }),
                  
                  // Ikon Kamera Kecil
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppTheme.brownDark,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text("Tap picture to change", style: TextStyle(fontSize: 12, color: Colors.grey)),
            // ---------------------------
            
            const SizedBox(height: 30),
            _buildTextField("Full Name", controller.nameController, Icons.person),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
              child: Obx(() => Text("Email: ${auth.userData['email'] ?? ''}", style: TextStyle(color: Colors.grey[600]))),
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