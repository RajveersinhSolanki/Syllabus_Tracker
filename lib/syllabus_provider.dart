import 'package:flutter/material.dart';
import 'dart:convert';
import 'syllabus.dart';

class SyllabusProvider extends ChangeNotifier {
  final List<Syllabus> _syllabus = [];

  // 🔹 Upcoming syllabus
  List<Syllabus> get upcoming =>
      _syllabus.where((e) => !e.isCompleted).toList();

  // 🔹 Completed syllabus
  List<Syllabus> get completed =>
      _syllabus.where((e) => e.isCompleted).toList();

  // 🔹 Toggle completion (FIX for your screen)
  void toggleComplete(int id) {
    final index = _syllabus.indexWhere((e) => e.id == id);

    if (index != -1) {
      _syllabus[index].isCompleted =
      !_syllabus[index].isCompleted;
      notifyListeners();
    }
  }

  // 🔹 Delete syllabus
  void delete(int id) {
    _syllabus.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // 🔹 Add syllabus
  void addSyllabus(Syllabus syllabus) {
    _syllabus.add(syllabus);
    notifyListeners();
  }

  // ===============================
  // 🔽 EXPORT SYLLABUS TO JSON
  // ===============================
  String exportToJson() {
    final data = _syllabus.map((e) => e.toJson()).toList();
    return jsonEncode(data);
  }

  // ===============================
  // 🔼 IMPORT SYLLABUS FROM JSON
  // ===============================
  void importFromJson(String jsonString) {
    final List decoded = jsonDecode(jsonString);

    _syllabus.clear();
    _syllabus.addAll(
      decoded.map((e) => Syllabus.fromJson(e)).toList(),
    );

    notifyListeners();
  }
}
