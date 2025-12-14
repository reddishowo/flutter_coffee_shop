import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/auth_service.dart';

class SignupView extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sign Up", style: TextStyle(fontFamily: 'Serif', fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            _buildInput("Full Name", nameController, false),
            const SizedBox(height: 20),
            _buildInput("Email Address", emailController, false),
            const SizedBox(height: 20),
            _buildInput("Password", passController, true),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AuthService.to.register(
                    nameController.text.trim(), 
                    emailController.text.trim(), 
                    passController.text.trim()
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brownDark,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
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
        fillColor: Colors.white,
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}