class ProjectCategory {
  late int id;
  late String name;
  late String description;

  ProjectCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ProjectCategory.fromJson(Map<String, dynamic> json) {
    return ProjectCategory(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
