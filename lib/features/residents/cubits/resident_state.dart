part of 'resident_cubit.dart';

/// Base state for resident management
abstract class ResidentState extends Equatable {
  const ResidentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ResidentInitial extends ResidentState {
  const ResidentInitial();
}

/// Loading state
class ResidentLoading extends ResidentState {
  const ResidentLoading();
}

/// Loaded state with residents list
class ResidentLoaded extends ResidentState {
  final List<Resident> residents;
  final ResidentStats stats;
  final String? searchQuery;

  const ResidentLoaded({
    required this.residents,
    required this.stats,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [residents, stats, searchQuery];
}

/// Saving state (during create/update/delete)
class ResidentSaving extends ResidentState {
  const ResidentSaving();
}

/// Saved state (after successful save)
class ResidentSaved extends ResidentState {
  final Resident resident;
  final String message;

  const ResidentSaved({required this.resident, required this.message});

  @override
  List<Object?> get props => [resident, message];
}

/// Deleted state
class ResidentDeleted extends ResidentState {
  final String message;

  const ResidentDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state
class ResidentError extends ResidentState {
  final String message;

  const ResidentError({required this.message});

  @override
  List<Object?> get props => [message];
}
