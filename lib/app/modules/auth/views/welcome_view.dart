import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground, // Light peach/cream
      body: Stack(
        children: [
          // Background decorations (Simple circles to mimic coffee beans)
          Positioned(
            top: -50, right: -50,
            child: Icon(Icons.coffee_rounded, size: 200, color: AppTheme.brownDark.withOpacity(0.05)),
          ),
          Positioned(
            bottom: 100, left: -50,
            child: Icon(Icons.coffee_rounded, size: 150, color: AppTheme.brownDark.withOpacity(0.05)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Coffee Cup Illustration (Using Icon for simplicity)
                  Image.network(
                    "https://cdn-icons-png.flaticon.com/512/2935/2935300.png", 
                    height: 180,
                    errorBuilder: (_,__,___) => const Icon(Icons.local_cafe, size: 100, color: AppTheme.brownDark),
                  ),
                  const SizedBox(height: 30),
                  
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontFamily: 'Serif', 
                      fontSize: 32, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black87
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Presenting something new and making it easier for users to make transactions.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(Routes.LOGIN),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.brownDark,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text("sign in", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(Routes.SIGNUP),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.creamBackground,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppTheme.brownDark),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text("sign up", style: TextStyle(color: AppTheme.brownDark, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}