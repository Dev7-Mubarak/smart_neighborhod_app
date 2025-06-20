enum ProjectPriority { 
  Low, Medium, High, Urgent }

extension ProjectPriorityExtension on ProjectPriority {
  String get displayName {
    switch (this) {
      case ProjectPriority.Low:
        return 'منخفضة';
      case ProjectPriority.Medium:
        return 'متوسطة';
      case ProjectPriority.High:
        return 'مرتفعة';
      case ProjectPriority.Urgent:
        return 'عاجلة';
    }
  }
   static ProjectPriority fromDisplayName(String name) {
    switch (name) {
      case 'منخفضة':
        return ProjectPriority.Low;
      case 'متوسطة':
        return ProjectPriority.Medium;
      case 'مرتفعة':
        return ProjectPriority.High;
      case 'عاجلة':
        return ProjectPriority.Urgent;    
      default:
        throw ArgumentError('Invalid ProjectPriority display name');
    }
}
}
