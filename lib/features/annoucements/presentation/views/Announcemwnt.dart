class Announcement {
  String title;
  DateTime date;
  String time;
  String details;
  String type;

  Announcement({
    required this.title,
    required this.date,
    required this.time,
    required this.details,
    required this.type,
  });

  // تحويل من JSON إلى كائن
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      title: json["title"],
      date: DateTime.parse(json["date"]), // تحويل النص إلى DateTime
      time: json["time"],
      details: json["details"],
      type: json["type"],
    );
  }
}
