import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../services/API/dio_consumer.dart';
import '../../database/database_service.dart';
import '../../features/confilct/data/dao/conflict_dao.dart';
import '../../features/confilct/data/dao/conflict_type_dao.dart';
import '../../features/confilct/data/datasources/conflict_local_datasource.dart';
import '../../features/confilct/data/datasources/conflict_remote_datasource.dart';
import '../../features/confilct/data/repositories/conflict_repository.dart';
import '../../features/confilct/services/conflict_sync_service.dart';
import '../../features/confilct/cubits/conflict/conflict_cubit.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize dependency injection
/// Call this before runApp() in main.dart
Future<void> initializeDependencies() async {
  // ============================================================================
  // CORE SERVICES
  // ============================================================================

  // Database Service - Singleton
  // Initialize the encrypted SQLite database
  final databaseService = DatabaseService.instance;
  await databaseService.database; // Trigger initialization
  getIt.registerSingleton<DatabaseService>(databaseService);

  // Dio HTTP Client - Singleton
  final dio = Dio();
  getIt.registerSingleton<Dio>(dio);

  // DioConsumer - Singleton
  // Wrapper around Dio with interceptors and error handling
  getIt.registerSingleton<DioConsumer>(DioConsumer(dio: dio));

  // ============================================================================
  // DATA ACCESS OBJECTS (DAOs)
  // ============================================================================

  // Conflict DAOs
  getIt.registerLazySingleton<ConflictDao>(
    () => ConflictDao(getIt<DatabaseService>()),
  );
  getIt.registerLazySingleton<ConflictTypeDao>(
    () => ConflictTypeDao(getIt<DatabaseService>()),
  );

  // ============================================================================
  // DATA SOURCES
  // ============================================================================

  // Conflict Local DataSource
  getIt.registerLazySingleton<ConflictLocalDataSource>(
    () => ConflictLocalDataSource(
      conflictDao: getIt<ConflictDao>(),
      conflictTypeDao: getIt<ConflictTypeDao>(),
    ),
  );

  // Conflict Remote DataSource
  getIt.registerLazySingleton<ConflictRemoteDataSource>(
    () => ConflictRemoteDataSource(api: getIt<DioConsumer>()),
  );

  // ============================================================================
  // REPOSITORIES
  // ============================================================================

  // Conflict Repository
  getIt.registerLazySingleton<ConflictRepository>(
    () => ConflictRepository(
      localDataSource: getIt<ConflictLocalDataSource>(),
      remoteDataSource: getIt<ConflictRemoteDataSource>(),
    ),
  );

  // ============================================================================
  // SYNC SERVICES
  // ============================================================================

  // Conflict Sync Service
  getIt.registerLazySingleton<ConflictSyncService>(
    () => ConflictSyncService(getIt<ConflictRepository>()),
  );

  // ============================================================================
  // CUBITS / BLOCS
  // ============================================================================

  // Conflict Cubit - Factory (new instance each time)
  getIt.registerFactory<ConflictCubit>(
    () => ConflictCubit(repository: getIt<ConflictRepository>()),
  );
}

/// Reset all registered dependencies
/// Useful for testing
Future<void> resetDependencies() async {
  await getIt.reset();
}
