import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  bool studyReminder = true;
  bool examAlert = true;
  bool weeklyReport = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // 🔵 Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                "Notification Settings",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: SwitchListTile(
                    title: const Text("Study Reminder"),
                    subtitle: const Text("Daily reminder to study"),
                    value: studyReminder,
                    onChanged: (value) {
                      setState(() => studyReminder = value);
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: SwitchListTile(
                    title: const Text("Exam Alerts"),
                    subtitle: const Text("Get notified before exams"),
                    value: examAlert,
                    onChanged: (value) {
                      setState(() => examAlert = value);
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: SwitchListTile(
                    title: const Text("Weekly Progress Report"),
                    subtitle: const Text("Receive weekly analytics"),
                    value: weeklyReport,
                    onChanged: (value) {
                      setState(() => weeklyReport = value);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}