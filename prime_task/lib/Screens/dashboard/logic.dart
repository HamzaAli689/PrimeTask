import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final eventController = EventController();
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  var upcomingTask = Rxn<Map<String, dynamic>>();

  @override
  void onReady() {
    super.onReady();
    if (uid != null) {
      _listenToTasks();
    }
  }

  void _listenToTasks() {
    FirebaseFirestore.instance
        .collection('Prime')
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {

      // Purane events saaf karein
      eventController.removeWhere((event) => true);

      List<Map<String, dynamic>> allTasks = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Firebase document ID ko save karein taake delete karte waqt kaam aaye
        data['id'] = doc.id;
        allTasks.add(data);

        Timestamp ts = data['date'] as Timestamp;
        DateTime date = ts.toDate();

        eventController.add(CalendarEventData(
          date: date,
          startTime: _parseTime(date, data['startTime']),
          endTime: _parseTime(date, data['endTime']),
          title: data['title'] ?? 'No Title',
          color: const Color(0xFFFFB88C),
          event: data['id'], // ID yahan pass kar di
        ));
      }

      // Sorting
      allTasks.sort((a, b) {
        DateTime dA = (a['date'] as Timestamp).toDate();
        DateTime dB = (b['date'] as Timestamp).toDate();
        return dA.compareTo(dB);
      });

      upcomingTask.value = allTasks.isNotEmpty ? allTasks.first : null;
      update();
    });
  }

  // Delete function (sirf delete rakha hai)
  Future<void> deleteTask(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Prime')
          .doc(uid)
          .collection('tasks')
          .doc(docId)
          .delete();
      Get.snackbar("Success", "Task delete ho gaya");
    } catch (e) {
      Get.snackbar("Error", "Task delete nahi ho saka");
    }
  }

  DateTime _parseTime(DateTime date, String timeString) {
    try {
      final format = DateFormat("h:mm a");
      final time = format.parse(timeString);
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    } catch (e) {
      return date;
    }
  }
}