import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TaskController extends GetxController {
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var startTime = TimeOfDay.now().obs;
  var endTime = TimeOfDay.now().obs;

  final titleController = TextEditingController();
  final descController = TextEditingController();

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context, initialDate: selectedDate.value, firstDate: DateTime(2020), lastDate: DateTime(2030));
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> pickTime(BuildContext context) async {
    TimeOfDay? start = await showTimePicker(context: context, initialTime: startTime.value);
    if (start != null) {
      startTime.value = start;
      TimeOfDay? end = await showTimePicker(context: context, initialTime: endTime.value);
      if (end != null) endTime.value = end;
    }
  }

  Future<void> saveTask(BuildContext context) async {
    if (titleController.text.isEmpty) {
      Get.snackbar("Error", "Title zaroori hai");
      return;
    }

    isLoading.value = true;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      // Sirf 'add' function rakha hai
      await FirebaseFirestore.instance.collection('Prime').doc(uid).collection('tasks').add({
        'title': titleController.text,
        'description': descController.text,
        'date': Timestamp.fromDate(selectedDate.value),
        'startTime': startTime.value.format(context),
        'endTime': endTime.value.format(context),
      });

      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Task save nahi ho saka: $e");
    } finally {
      isLoading.value = false;
    }
  }
}