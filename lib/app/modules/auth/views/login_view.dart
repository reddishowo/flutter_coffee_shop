import 'package:coffee_shop/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(), 
                icon: const Icon(Icons.arrow_back, color: Colors.black)
              ),
              const SizedBox(height: 20),
              
              // Title
              const Text("sign in", style: TextStyle(fontFamily: 'Serif', fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                "Log in to make it easier when using the application.",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Inputs
              _buildInput("Username / Email", emailController, false),
              const SizedBox(height: 20),
              _buildInput("Password", passController, true),
              
              // Forgot Pass
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, 
                  child: const Text("Forget Password?", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
                ),
              ),
              
              const SizedBox(height: 20),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AuthService.to.login(emailController.text.trim(), passController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brownDark,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("sign in", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Serif')),
                ),
              ),

              const SizedBox(height: 40),

              // Google Button (Visual only for now)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30)
                ),
                child: ListTile(
                  leading: const Icon(Icons.g_mobiledata, size: 40, color: Colors.red), // Placeholder for Google Logo
                  title: const Text("Continue with email", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Serif')),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController controller, bool isPass) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300], // Matches the gray bars in image
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold, color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}