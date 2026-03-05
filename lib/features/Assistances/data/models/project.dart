import 'package:smart_negborhood_app/features/Assistances/data/models/project_catgory.dart';

import '../../../../core/common/enums/project_priority.dart';
import '../../../../core/common/enums/project_status.dart';

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
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      projectStatus: _projectStatusFromString(json["projectStatus"]),
      projectPriority: _projectPriorityFromString(json["projectPriority"]),
      budget: json["budget"] ?? 0,
      manager: _extractManager(json),
      projectCategory: ProjectCategory.fromJson(json["projectCatgory"] ?? {}),
    );
  }

  static Manager _extractManager(Map<String, dynamic> json) {
    int managerId = json["managerId"] ?? 0;
    String managerName = "";

    if (json["manager"] != null && json["manager"] is Map<String, dynamic>) {
      final managerJson = json["manager"];
      managerId = managerJson["id"] ?? managerId;

      // Handle the case where the backend returns a Person object instead of a direct fullName
      final firstName = managerJson['firstName'] as String? ?? '';
      final lastName = managerJson['lastName'] as String? ?? '';
      final fullName =
          managerJson['fullName'] as String? ??
          managerJson['name'] as String? ??
          '';

      if (fullName.isNotEmpty) {
        managerName = fullName;
      } else if (firstName.isNotEmpty || lastName.isNotEmpty) {
        managerName = '$firstName $lastName'.trim();
      }
    }

    return Manager(
      id: managerId,
      fullName: managerName.isEmpty ? "غير محدد" : managerName,
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

  Manager({required this.id, required this.fullName});

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(id: json["id"] ?? 0, fullName: json["fullName"] ?? "");
  }
}
