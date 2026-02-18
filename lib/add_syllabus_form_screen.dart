import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'syllabus_provider.dart';
import 'syllabus.dart';
import 'home_screen.dart';

class AddSyllabusFormScreen extends StatefulWidget {
  const AddSyllabusFormScreen({super.key});

  @override
  State<AddSyllabusFormScreen> createState() =>
      _AddSyllabusFormScreenState();
}

class _AddSyllabusFormScreenState
    extends State<AddSyllabusFormScreen> {

  final subjectController = TextEditingController();
  final topicController = TextEditingController();
  final instructionController = TextEditingController();
  final dateController = TextEditingController();

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<SyllabusProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // 🔹 Subject
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // 🔹 Topic
              TextField(
                controller: topicController,
                decoration: const InputDecoration(
                  labelText: "Topic",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // 🔹 Instruction
              TextField(
                controller: instructionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Instruction",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // 🔹 Date Picker (NO PAST DATE)
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Select Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {

                  DateTime today = DateTime.now();

                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: today,
                    firstDate: DateTime(
                        today.year,
                        today.month,
                        today.day), // 🚫 No past
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    selectedDate = picked;
                    dateController.text =
                    "${picked.day}/${picked.month}/${picked.year}";
                  }
                },
              ),

              const SizedBox(height: 25),

              // 🔹 Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (subjectController.text.isEmpty ||
                        topicController.text.isEmpty ||
                        instructionController.text.isEmpty ||
                        dateController.text.isEmpty) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all fields"),
                        ),
                      );
                      return;
                    }

                    provider.addSyllabus(
                      Syllabus(
                        id: DateTime.now()
                            .millisecondsSinceEpoch,
                        subject: subjectController.text,
                        topic: topicController.text,
                        subTopic: instructionController.text,
                        classOrSem: dateController.text,
                      ),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                          const HomeScreen()),
                          (route) => false,
                    );
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
