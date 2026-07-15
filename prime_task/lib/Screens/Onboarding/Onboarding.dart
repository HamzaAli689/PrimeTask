import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../signUp/view.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6FC6C9),
              Color(0xFFFFB88C),
              Color(0xFFFF6B6B),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Top Left Half Circles
            _buildCircle(top: -50, left: -50, size: 200, opacity: 0.6),
            _buildCircle(top: -14, left: -14, size: 250, opacity: 0.6),

            // Middle Circle
            _buildCircle(top: 480, left: 50, size: 60, opacity: 0.5, width: 3),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 3),
                  const Text(
                    "PrimeTask\nStreamline\nyour world",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Organize your tasks, manage your time, and stay focused. PrimeTask helps you turn your goals into achievements with ease.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2D2D2D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Register Now",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        // GetX Navigation
                        onTap: () {
                          // GetX ki madad se navigation
                          Get.to(() => const SignUPPage(), transition: Transition.rightToLeftWithFade, duration: const Duration(seconds: 1));
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: const Icon(Icons.arrow_forward, size: 30),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Circles
  Widget _buildCircle({required double top, required double left, required double size, required double opacity, double width = 1.5}) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(opacity), width: width),
        ),
      ),
    );
  }
}