class Syllabus {
  final int id;
  final String classOrSem;
  final String subject;
  final String topic;
  final String subTopic;
  bool isCompleted;

  Syllabus({
    required this.id,
    required this.classOrSem,
    required this.subject,
    required this.topic,
    required this.subTopic,
    this.isCompleted = false,
  });

  // 🔽 Convert object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classOrSem': classOrSem,
      'subject': subject,
      'topic': topic,
      'subTopic': subTopic,
      'isCompleted': isCompleted,
    };
  }

  // 🔼 Convert JSON → object
  factory Syllabus.fromJson(Map<String, dynamic> json) {
    return Syllabus(
      id: json['id'],
      classOrSem: json['classOrSem'],
      subject: json['subject'],
      topic: json['topic'],
      subTopic: json['subTopic'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
