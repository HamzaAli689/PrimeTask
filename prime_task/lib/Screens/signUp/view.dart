import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:prime_task/widgets/background_decoration.dart';
import 'package:prime_task/widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'logic.dart';

class SignUPPage extends StatelessWidget {
  const SignUPPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignUPLogic logic = Get.put(SignUPLogic());

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
                  const Gap(130),
                  const Text("Register", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)),
                  const Text("Fill the form below for registering into the system", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 40),

                  CustomTextField(controller: logic.nameController, hint: 'Name', icon: Icons.person_outline),
                  const SizedBox(height: 20),
                  CustomTextField(controller: logic.emailController, hint: 'Email', icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  CustomTextField(controller: logic.passwordController, hint: 'Password', icon: Icons.lock_outline, obscure: true),
                  const SizedBox(height: 50),

                  // Loading Logic with Obx
                  Obx(() => logic.isLoading.value
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B6B)))
                      : CustomButton(text: "Register", onPressed: () => logic.registerUser())),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B6B))),
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