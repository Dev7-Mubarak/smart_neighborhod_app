import 'package:smart_neighborhod_app/models/project_catgory.dart';

import 'enums/project_priority.dart';
import 'enums/project_status.dart';

class Project {
  late int id;
  late String name;
  late String description;
  late DateTime? startDate;
  late DateTime? endDate;
  late ProjectStatus projectStatus;
  late ProjectPriority projectPriority;
  late int budget;
  late Manager manager;
  late ProjectCategory projectCategory;

  Project({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.projectStatus,
    required this.projectPriority,
    required this.budget,
    required this.manager,
    required this.projectCategory,
    required this.id,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json["id"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      startDate: DateTime.parse(json['startDate'] as String),
      endDate:json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      projectStatus:_projectStatusFromString(json["projectStatus"]),
      projectPriority:_projectPriorityFromString( json["projectPriority"]) ,
      budget: json["budget"] ?? 0,
      manager: Manager.fromJson(json["manager"] ?? {}),
      projectCategory: ProjectCategory.fromJson(json["projectCatgory"] ?? {}),
    );
  }
  static ProjectStatus _projectStatusFromString(String value) {
    try {
    return ProjectStatusExtension.fromDisplayName(value);
  } catch (e) {
    return ProjectStatus.Planned;
  }
    // ProjectStatus _projectStatus=
  //   return ProjectStatus.values.firstWhere(
  //     (e) => e.toString().split('.').last == value,
  //     orElse: () => ProjectStatus.Planned,
  // );
  }
    static ProjectPriority _projectPriorityFromString(String value) {
        try {
    return ProjectPriorityExtension.fromDisplayName(value);
  } catch (e) {
    return ProjectPriority.Low;
  }
    // return ProjectPriority.values.firstWhere(
    //   (e) => e.toString().split('.').last == value,
    //   orElse: () => ProjectPriority.Low,
    // );
  }
}

class Manager {
  late int id;
  late String fullName;

  Manager({
    required this.id,
    required this.fullName,
  });

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      id: json["id"] ?? 0,
      fullName: json["fullName"] ?? "",
    );
  }
}

  

