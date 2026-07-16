import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:prime_task/Screens/signUp/view.dart';
import 'package:prime_task/widgets/background_decoration.dart';
import 'package:prime_task/widgets/custom_button.dart';
import 'package:prime_task/widgets/custom_textfield.dart';
import 'login_logic.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginLogic logic = Get.put(LoginLogic());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: Stack(
        children: [
          BackgroundDecoration(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(150),
                  const Text("Sign In", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)),
                  const Text("Enter your email and password to continue", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 40),

                  CustomTextField(controller: logic.emailController, hint: "Email", icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  CustomTextField(controller: logic.passwordController, hint: "Password", icon: Icons.lock_outline, obscure: true),
                  const SizedBox(height: 50),

                  // Loading Logic with Obx
                  Obx(() => logic.isLoading.value
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B6B)))
                      : CustomButton(text: "Sign In", onPressed: () => logic.loginUser())),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Get.to(() => const SignUPPage(), transition: Transition.leftToRightWithFade, duration: const Duration(seconds: 1)),
                        child: const Text("Register", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B6B))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}