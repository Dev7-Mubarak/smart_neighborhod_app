class ConflictType{
  late int id;
  late String name;

  ConflictType({
    required this.id,
    required this.name,
  });

  factory ConflictType.fromJson(Map<String, dynamic> json) {
    return ConflictType(
      id: json["id"],
      name:json["name"],
    );
  }
}

