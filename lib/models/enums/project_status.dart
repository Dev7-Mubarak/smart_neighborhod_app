enum ProjectStatus { Planned, InProgress, Completed, Cancelled }

extension ProjectStatusExtension on ProjectStatus {
  String get displayName {
    switch (this) {
      case ProjectStatus.Planned:
        return 'تحت التخطيط';
      case ProjectStatus.InProgress:
        return 'قيد التنفيذ';
      case ProjectStatus.Completed:
        return 'مكتمل';
      case ProjectStatus.Cancelled:
        return 'ملغى';
    }
  }
  
  static ProjectStatus fromDisplayName(String name) {
    switch (name) {
      case 'تحت التخطيط':
        return ProjectStatus.Planned;
      case 'قيد التنفيذ':
        return ProjectStatus.InProgress;
      case 'مكتمل':
        return ProjectStatus.Completed;
      case 'ملغى':
        return ProjectStatus.Cancelled;    
      default:
        throw ArgumentError('Invalid ProjectStatus display name');
    }
  }
  
}
