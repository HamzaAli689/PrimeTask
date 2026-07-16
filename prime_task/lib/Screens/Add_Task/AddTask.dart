import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:prime_task/widgets/background_decoration.dart';
import 'TaskController.dart';

class NewTaskScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFD),
      body: Stack(
        children: [
          BackgroundDecoration(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Gap(60),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Get.back(),
                      ),
                      Gap(10),
                      const Text("New Task", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  TextField(controller: taskController.titleController, decoration: const InputDecoration(hintText: "Title", border: UnderlineInputBorder())),
                  const SizedBox(height: 20),
                  TextField(controller: taskController.descController, decoration: const InputDecoration(hintText: "Description", border: UnderlineInputBorder())),

                  const SizedBox(height: 30),

                  Obx(() => ListTile(
                    leading: const Icon(Icons.calendar_today, color: Color(0xFFFF6B6B)),
                    title: const Text("Due Date"),
                    subtitle: Text(DateFormat('dd MMMM yyyy').format(taskController.selectedDate.value)),
                    onTap: () => taskController.pickDate(context),
                  )),

                  Obx(() => ListTile(
                    leading: const Icon(Icons.access_time, color: Color(0xFFFF6B6B)),
                    title: const Text("Time"),
                    subtitle: Text("${taskController.startTime.value.format(context)} - ${taskController.endTime.value.format(context)}"),
                    onTap: () => taskController.pickTime(context),
                  )),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: taskController.isLoading.value
                          ? null
                          : () => taskController.saveTask(context),
                      child: taskController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Task", style: TextStyle(color: Colors.white, fontSize: 18)),
                    )),
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