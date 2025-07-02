class Assistance {
  final int id;
  final String name;
  final String deliverDate;
  final String notes;

  Assistance(
    this.name, {
    required this.id,
    required this.deliverDate,
    required this.notes,
  });

  factory Assistance.fromJson(Map<String, dynamic> json) {
    return Assistance(
      json["name"] ?? "",
      id: json["id"] ?? 0,
      deliverDate: json["deliverDate"] ?? "",
      notes: json["notes"] ?? "",
    );
  }
}
