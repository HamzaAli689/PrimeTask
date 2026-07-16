import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailsLogic extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var highlightTask = Rxn<Map<String, dynamic>>();

  Future<void> deleteTask(String uid, String docId) async {
    try {
      await _firestore.collection('Prime').doc(uid).collection('tasks').doc(docId).delete();
      Get.snackbar("Success", "Task deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Could not delete task: $e");
    }
  }

  void findHighlightTask(List<QueryDocumentSnapshot> tasks) {
    if (tasks.isEmpty) {
      highlightTask.value = null;
      return;
    }

    DateTime now = DateTime.now();
    Map<String, dynamic>? nextTask;

    for (var doc in tasks) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime start = _parseTime(DateTime.now(), data['startTime']);
      DateTime end = _parseTime(DateTime.now(), data['endTime']);

      if (now.isAfter(start) && now.isBefore(end)) {
        highlightTask.value = data;
        return;
      }
      if (start.isAfter(now)) {
        if (nextTask == null || start.isBefore(_parseTime(DateTime.now(), nextTask['startTime']))) {
          nextTask = data;
        }
      }
    }
    highlightTask.value = nextTask ?? (tasks.first.data() as Map<String, dynamic>);
  }

  bool isCurrentTask(String startTime, String endTime, DateTime taskDate) {
    DateTime now = DateTime.now();
    if (taskDate.year != now.year || taskDate.month != now.month || taskDate.day != now.day) return false;
    DateTime start = _parseTime(taskDate, startTime);
    DateTime end = _parseTime(taskDate, endTime);
    return now.isAfter(start) && now.isBefore(end);
  }

  DateTime _parseTime(DateTime date, String timeString) {
    try {
      final format = DateFormat("h:mm a");
      final time = format.parse(timeString);
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    } catch (e) { return date; }
  }
}