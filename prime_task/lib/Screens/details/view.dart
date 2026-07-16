import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../Add_Task/AddTask.dart';
import 'logic.dart';

class DetailsPage extends StatelessWidget {
  final DateTime selectedDate;

  DetailsPage({Key? key, required this.selectedDate}) : super(key: key);

  final DetailsLogic logic = Get.put(DetailsLogic());
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFD),
      appBar: AppBar(
        title: Text(DateFormat('d MMMM, yyyy').format(selectedDate)),
        backgroundColor: const Color(0xFFFF6B6B),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6B6B),
        onPressed: () => Get.to(() => NewTaskScreen()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Prime')
            .doc(uid)
            .collection('tasks')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B6B)),
            );
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(child: Text("No tasks found"));

          var tasks = snapshot.data!.docs.where((doc) {
            DateTime taskDate = (doc['date'] as Timestamp).toDate();
            return taskDate.year == selectedDate.year &&
                taskDate.month == selectedDate.month &&
                taskDate.day == selectedDate.day;
          }).toList();

          if (tasks.isEmpty)
            return const Center(child: Text("No tasks for this day"));

          // Logic call for Gradient Card
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => logic.findHighlightTask(tasks),
          );

          return Column(
            children: [
              const SizedBox(height: 20),
              // Dynamic Gradient Card
              Obx(
                () => Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6B6BFF), Color(0xFFFF6B6B)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: logic.highlightTask.value == null
                      ? const Text(
                          "No tasks for this time",
                          style: TextStyle(color: Colors.white,),
                        )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Active/Next Task",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Gap(5),
                          Text(
                            logic.highlightTask.value!['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(5),
                          Text(
                              logic.highlightTask.value!['description'] ?? "No description",
                              style: const TextStyle(color: Colors.white70, fontSize: 14)
                          ),
                          Gap(7),
                          Text(
                            "${logic.highlightTask.value!['startTime']} - ${logic.highlightTask.value!['endTime']}",
                            style: const TextStyle(color: Colors.white,fontSize: 14,),
                          ),
                        ],
                      ),
                ),
              ),
              Gap(35),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Today's schedule",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                    ),
                  ),
                ),
              ),
              Gap(15),

              // ListView
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var data = tasks[index].data() as Map<String, dynamic>;
                    bool isCurrent = logic.isCurrentTask(
                      data['startTime'],
                      data['endTime'],
                      selectedDate,
                    );

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? Colors.red.withOpacity(0.05)
                            : Colors.white,
                        border: Border.all(
                          color: isCurrent ? Colors.red : Colors.grey.shade300,
                          width: isCurrent ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        title: Text(
                          data['title'] ?? "No Title",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrent ? Colors.red : Colors.black,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            // Time row
                            Text(
                              "${data['startTime']} - ${data['endTime']}",
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            // Description add ho gayi
                            Text(
                              data['description'] ?? "No description available",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Delete",
                              middleText: "Are you sure you want to delete this task?",
                              buttonColor: Colors.red,
                              confirmTextColor: Colors.white,
                              textConfirm: "Delete",
                              textCancel: "Cancel",
                              onConfirm: () {
                                logic.deleteTask(uid, tasks[index].id);
                                Get.back();
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
