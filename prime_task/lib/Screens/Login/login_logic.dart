import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../dashboard/view.dart';

class LoginLogic extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> loginUser() async {
    // Basic validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }
    isLoading.value = true;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar("Success", "Welcome Back!");
      Get.offAll(() => const DashboardPage());
      // Yahan aap apni home screen ka route daal sakte hain
      // Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString());
      isLoading.value = false;
    }
  }
}