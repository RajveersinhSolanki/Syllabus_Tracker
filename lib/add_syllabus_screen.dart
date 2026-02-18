import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'notes_screen.dart';
import 'statistics_screen.dart';
import 'add_syllabus_form_screen.dart';
import 'syllabus_provider.dart';
import 'syllabus.dart';

class AddSyllabusScreen extends StatefulWidget {
  const AddSyllabusScreen({super.key});

  @override
  State<AddSyllabusScreen> createState() => _AddSyllabusScreenState();
}

class _AddSyllabusScreenState extends State<AddSyllabusScreen> {
  int _selectedIndex = 3;
  String searchQuery = "";

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotesScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StatisticsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SyllabusProvider>(context);

    final filteredList = provider.upcoming
        .where((item) => item.subject
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),

      body: Column(
        children: [

          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by Subject...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // 🔹 Grid View
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
              child: Text(
                "No Tasks Found",
                style: TextStyle(fontSize: 18),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final Syllabus item =
                filteredList[index];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(15),
                    color: Colors.indigo.shade50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset:
                        const Offset(2, 4),
                      ),
                    ],
                  ),
                  padding:
                  const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      // 🔹 Subject + 3 Dot Menu
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.subject,
                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow:
                              TextOverflow.ellipsis,
                            ),
                          ),

                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value ==
                                  'delete') {
                                provider.delete(
                                    item.id);
                              }
                            },
                            itemBuilder:
                                (context) =>
                            const [
                              PopupMenuItem(
                                value:
                                'delete',
                                child:
                                Text(
                                    "Delete"),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                          "Topic: ${item.topic}"),
                      const SizedBox(height: 6),

                      Text(
                        "Instruction: ${item.subTopic}",
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      Text(
                          "Date: ${item.classOrSem}"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddSyllabusFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar:
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor:
        Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: "Notes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Statistics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: "Task",
          ),
        ],
      ),
    );
  }
}
