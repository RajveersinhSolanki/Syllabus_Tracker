import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notes_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';
import 'package:syllabus/add_syllabus_screen.dart';
import 'syllabus_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController _pageController =
  PageController(viewportFraction: 0.55);

  Timer? _timer;

  final List<String> motivationQuotes = [
    "Push yourself, because no one else will do it for you.",
    "Success doesn’t find you. You go get it.",
    "Small progress is still progress.",
    "Don’t stop until you’re proud.",
    "Dream big. Work hard. Stay focused.",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotesScreen()),
      );
      return;
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StatisticsScreen()),
      );
      return;
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddSyllabusScreen()),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  String _getFormattedDate() {
    DateTime now = DateTime.now();

    List<String> weekdays = [
      "Monday","Tuesday","Wednesday","Thursday",
      "Friday","Saturday","Sunday"
    ];

    List<String> months = [
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];

    return "${weekdays[now.weekday - 1]}, "
        "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SyllabusProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int completedCount = provider.completed.length;
    int pendingCount = provider.upcoming.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Syllabus Tracker"),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(   // ✅ FIXED HERE
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// DATE
                  Text(
                    _getFormattedDate(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// COUNTERS
                  Row(
                    children: [
                      Expanded(
                        child: _modernCard(
                          count: completedCount,
                          line1: "Completed",
                          line2: "Tasks",
                          icon: Icons.school,
                          iconBg: const Color(0xffE6E4FF),
                          iconColor: const Color(0xff6C63FF),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _modernCard(
                          count: pendingCount,
                          line1: "Pending",
                          line2: "Tasks",
                          icon: Icons.assignment,
                          iconBg: const Color(0xffFFF2D9),
                          iconColor: const Color(0xffF4A100),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  /// MOTIVATION
                  const Text(
                    "Stay Motivated 🚀",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        final quote =
                        motivationQuotes[index % motivationQuotes.length];

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFFFFF),
                                Color(0xFFE0F7FA)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              quote,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30), // ✅ Extra bottom space
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Statistics"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Task"),
        ],
      ),
    );
  }

  Widget _modernCard({
    required int count,
    required String line1,
    required String line2,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffF5F6FA),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(line1,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.black54)),
                Text(line2,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
