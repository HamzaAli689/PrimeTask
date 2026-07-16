import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_task/widgets/background_decoration.dart';
import '../Add_Task/AddTask.dart';
import '../details/view.dart';
import 'logic.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller ko initialize karein
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFD),
      body: Stack(
        children: [
          BackgroundDecoration(),
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Schedule", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
                  ),
                ),

                // Gradient Card
                Obx(() => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF6B6BFF), Color(0xFFFF6B6B)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: controller.upcomingTask.value == null
                      ? const Text("No upcoming tasks", style: TextStyle(color: Colors.white))
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(controller.upcomingTask.value!['title'] ?? "Task", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(controller.upcomingTask.value!['description'] ?? "", style: const TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
                        ]),
                      ),
                      Text(controller.upcomingTask.value!['startTime'] ?? "", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),

                const SizedBox(height: 20),

                // Calendar
                Expanded(
                  child: GetBuilder<DashboardController>(
                    builder: (controller) {
                      return CalendarControllerProvider(
                        controller: controller.eventController,
                        child: DayView(
                          // Update logic hatane ke baad onEventTap ko simple rakha hai
                          // Agar aap DetailsPage (jahan Delete hota hai) rakhna chahte hain to ye line rehne dein
                          onEventTap: (events, date) => Get.to(() => DetailsPage(selectedDate: date)),

                          initialDay: DateTime.now(),
                          headerStyle: const HeaderStyle(
                            headerTextStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,

                            ),
                            decoration: BoxDecoration(color: Color(0xFFFF6B6B)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6B6B),
        onPressed: () => Get.to(() => NewTaskScreen()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}