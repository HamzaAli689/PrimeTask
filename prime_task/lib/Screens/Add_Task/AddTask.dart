import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewTaskScreen extends StatefulWidget {
  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
        context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: isStart ? startTime : endTime);
    if (picked != null) {
      setState(() => isStart ? startTime = picked : endTime = picked);
    }
  }

  // FUNCTION KO YAHAN BAAHAR RAKHEIN
  Future<void> saveTaskToFirestore() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      DateTime finalDateTime = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day,
        startTime.hour, startTime.minute,
      );

      await FirebaseFirestore.instance
          .collection('Prime')
          .doc(uid)
          .collection('tasks')
          .add({
        'title': titleController.text,
        'description': descController.text,
        'date': Timestamp.fromDate(finalDateTime),
        'startTime': startTime.format(context),
        'endTime': endTime.format(context),
        'isCompleted': false,
      });

      print("Task add ho gaya Firestore par");
      Get.back(); // Ab ye kaam karega!
    } catch (e) {
      Get.snackbar("Error", "Task save nahi ho saka: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFD),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Get.back())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("New Task", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(controller: titleController, decoration: const InputDecoration(hintText: "Title of Task", border: UnderlineInputBorder())),
            const SizedBox(height: 20),
            TextField(controller: descController, decoration: const InputDecoration(hintText: "Description", border: UnderlineInputBorder())),
            const SizedBox(height: 30),
            ListTile(leading: const Icon(Icons.calendar_today, color: Color(0xFFFF6B6B)), title: const Text("Due Date"), subtitle: Text(DateFormat('dd MMMM yyyy').format(selectedDate)), onTap: _pickDate),
            ListTile(leading: const Icon(Icons.access_time, color: Color(0xFFFF6B6B)), title: const Text("Time"), subtitle: Text("${startTime.format(context)} - ${endTime.format(context)}"), onTap: () => _pickTime(true).then((value) => _pickTime(false))),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: saveTaskToFirestore, // FUNCTION CALL YAHAN HOGA
                child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}