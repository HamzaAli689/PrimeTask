import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../widgets/background_decoration.dart';
import '../Add_Task/AddTask.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _currentDate = DateTime.now();
  final GlobalKey<DayViewState> _dayViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final eventController = CalendarControllerProvider.of(context).controller;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFD),
      body: SafeArea(
        child: Column(
          children: [
            // Header Title

            Padding(
              padding: EdgeInsets.all(25.0),
              child: Align(alignment: Alignment.centerLeft, child: Text("Schedule", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
            ),

            // Gradient Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6B6BFF), Color(0xFFFF6B6B)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Client Meeting", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("o Proposal Recruitment", style: TextStyle(color: Colors.white70)),
                  ]),
                  Text("2.30 PM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // DayView
            Expanded(
              child: uid == null
                  ? const Center(child: Text("No user logged in"))
                  : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Prime').doc(uid).collection('tasks').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    eventController.removeWhere((event) => true);
                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      DateTime date = (data['date'] as Timestamp).toDate();
                      DateTime start = _combineDateTime(date, data['startTime']);
                      DateTime end = _combineDateTime(date, data['endTime']);

                      eventController.add(CalendarEventData(
                        date: date,
                        startTime: start,
                        endTime: end,
                        title: data['title'] ?? 'No Title',
                      ));
                    }
                  }

                  return DayView(
                    key: _dayViewKey,
                    initialDay: _currentDate,
                    showHalfHours: false,
                    showVerticalLine: false,
                    headerStyle: HeaderStyle(
                      headerTextStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                      decoration: BoxDecoration(color: Color(0xFFFFB88C).withOpacity(0.5),)
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6B6B),
        onPressed: () => Get.to(() => NewTaskScreen()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  DateTime _combineDateTime(DateTime date, String timeString) {
    try {
      final format = DateFormat("d MMMM yyyy");
      final time = format.parse(timeString);
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    } catch (e) { return date; }
  }
}