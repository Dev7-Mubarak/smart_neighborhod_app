import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._();
  static const String _dbName = 'smart_neighbourhood.db';
  static const int _dbVersion = 6;

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _keyAlias = 'db_encryption_key';

  DatabaseService._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the encrypted SQLite database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    final encryptionKey = await _getOrCreateEncryptionKey();

    return await openDatabase(
      path,
      version: _dbVersion,
      password: encryptionKey,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Get existing key or create a new secure random key
  Future<String> _getOrCreateEncryptionKey() async {
    String? existingKey = await _secureStorage.read(key: _keyAlias);

    if (existingKey != null) {
      return existingKey;
    }

    // Generate a cryptographically secure 256-bit key
    final random = Random.secure();
    final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
    final newKey = keyBytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    // Store securely in platform keychain/keystore
    await _secureStorage.write(key: _keyAlias, value: newKey);

    return newKey;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add sync operations table if not exists (legacy migration)
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sync_operations (
          operation_id TEXT PRIMARY KEY,
          entity_type TEXT NOT NULL,
          entity_id TEXT NOT NULL,
          operation_type TEXT NOT NULL,
          payload TEXT NOT NULL,
          created_at TEXT NOT NULL,
          attempt_count INTEGER DEFAULT 0,
          last_attempt_at TEXT,
          last_error TEXT,
          completed_at TEXT
        )
      ''');
    }

    if (oldVersion < 3) {
      // Add all new feature tables
      await _createV3Tables(db);
      // Add indexes for better query performance
      await _createAllIndexes(db);
    }

    if (oldVersion < 4) {
      // Drop and recreate some refactored feature tables
      await db.execute('DROP TABLE IF EXISTS announcements');
      await db.execute('DROP TABLE IF EXISTS teams');
      await db.execute('DROP TABLE IF EXISTS residential_neighborhoods');
      await db.execute('DROP TABLE IF EXISTS residential_neighbourhoods');
      await db.execute('DROP TABLE IF EXISTS residential_blocks');
      await db.execute('DROP TABLE IF EXISTS residential_units');

      await _createAnnouncementsTable(db);
      await _createTeamsTable(db);
      await _createResidentialTables(db);
    }

    if (oldVersion < 5) {
      // Destructive migration: change all primary keys / FK fields to INTEGER.
      // Drop all existing tables and recreate schema with integer IDs (local data will be lost).
      final tablesToDrop = [
        'residents',
        'issues',
        'persons',
        'residential_units',
        'residential_neighborhoods',
        'residential_neighbourhoods',
        'residential_blocks',
        'family_categories',
        'families',
        'family_member_roles',
        'family_members',
        'teams',
        'team_roles',
        'team_members',
        'conflict_types',
        'conflicts',
        'government_institutions',
        'government_institution_contacts',
        'managers',
        'project_categories',
        'projects',
        'assistances',
        'announcements',
        'sync_log',
        'sync_operations',
        'manual_conflict_queue',
        'conflict_resolution_log',
        'field_conflicts',
        'sync_performance_log',
      ];

      for (final t in tablesToDrop) {
        await db.execute('DROP TABLE IF EXISTS $t');
      }

      await _onCreate(db, newVersion);
    }

    if (oldVersion < 6) {
      // Add server_id indexes for efficient sync lookups
      await _createServerIdIndexes(db);
    }
  }

  Future<void> _createResidentialTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS residential_neighbourhoods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        address TEXT,
        status TEXT,
        manager_id INTEGER,
        metadata TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS residential_blocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        code TEXT NOT NULL,
        neighbourhood_id INTEGER,
        description TEXT,
        status TEXT,
        metadata TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS residential_units (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        unit_number TEXT NOT NULL,
        block_id INTEGER,
        floor INTEGER DEFAULT 0,
        number_of_rooms INTEGER DEFAULT 1,
        status TEXT,
        metadata TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');
  }

  Future<void> _createTeamsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS teams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        status TEXT,
        neighbourhood_id INTEGER,
        block_id INTEGER,
        metadata TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');
  }

  Future<void> _createAnnouncementsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS announcements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT,
        type TEXT,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        author_id INTEGER NOT NULL,
        neighbourhood_id INTEGER,
        block_id INTEGER,
        published_at TEXT,
        expires_at TEXT,
        attachments TEXT,
        metadata TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');
  }

  /// Create all tables on first database creation
  Future<void> _onCreate(Database db, int version) async {
    // =============================================
    // CORE ENTITIES
    // =============================================

    // Residents table
    await db.execute('''
      CREATE TABLE residents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        national_id TEXT NOT NULL,
        full_name TEXT NOT NULL,
        phone TEXT,
        unit_id INTEGER,
        block_id INTEGER,
        neighbourhood_id INTEGER,
        status TEXT DEFAULT 'active',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Issues/Complaints table
    await db.execute('''
      CREATE TABLE issues (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        priority TEXT DEFAULT 'medium',
        status TEXT DEFAULT 'open',
        reporter_id INTEGER,
        assigned_to INTEGER,
        unit_id INTEGER,
        block_id INTEGER,
        neighbourhood_id INTEGER,
        resolution_notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        resolved_at TEXT,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // =============================================
    // PEOPLE FEATURE
    // =============================================

    // Persons table
    await db.execute('''
      CREATE TABLE persons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        second_name TEXT,
        third_name TEXT,
        last_name TEXT NOT NULL,
        date_of_birth TEXT,
        phone_number TEXT,
        image TEXT,
        gender TEXT,
        blood_type TEXT,
        occupation_status TEXT,
        marital_status TEXT,
        job TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // =============================================
    // RESIDENTIAL HIERARCHY
    // =============================================
    await _createResidentialTables(db);

    // =============================================
    // FAMILIES FEATURE
    // =============================================

    // Family Categories table
    await db.execute('''
      CREATE TABLE family_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Families table
    await db.execute('''
      CREATE TABLE families (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT,
        family_category_id INTEGER,
        family_notes TEXT,
        block_id INTEGER,
        family_head_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Family Member Roles table
    await db.execute('''
      CREATE TABLE family_member_roles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        role_name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Family Members junction table
    await db.execute('''
      CREATE TABLE family_members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        family_id INTEGER NOT NULL,
        person_id INTEGER NOT NULL,
        role_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // =============================================
    // TEAMS FEATURE
    // =============================================
    await _createTeamsTable(db);

    // Team Roles table
    await db.execute('''
      CREATE TABLE team_roles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Team Members junction table
    await db.execute('''
      CREATE TABLE team_members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        team_id INTEGER NOT NULL,
        person_id INTEGER NOT NULL,
        person_name TEXT,
        date_of_join TEXT,
        team_role_id INTEGER,
        team_role_name TEXT,
        team_name TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // =============================================
    // CONFLICTS FEATURE
    // =============================================

    // Conflict Types table
    await db.execute('''
      CREATE TABLE conflict_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Conflicts table
    await db.execute('''
      CREATE TABLE conflicts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        conflict_type_id INTEGER,
        conflict_type_name TEXT,
        manager_name TEXT,
        first_party_id INTEGER,
        first_party_name TEXT,
        second_party_id INTEGER,
        second_party_name TEXT,
        notes TEXT,
        image_url TEXT,
        session_date TEXT,
        is_resolved INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // =============================================
    // GOVERNMENT INSTITUTIONS FEATURE
    // =============================================

    // Government Institutions table
    await db.execute('''
      CREATE TABLE government_institutions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Government Institution Contacts table
    await db.execute('''
      CREATE TABLE government_institution_contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        institution_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        job TEXT,
        phone TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // =============================================
    // ASSISTANCES FEATURE
    // =============================================

    // Managers table
    await db.execute('''
      CREATE TABLE managers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Project Categories table
    await db.execute('''
      CREATE TABLE project_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Projects table
    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        start_date TEXT,
        end_date TEXT,
        project_status TEXT,
        project_priority TEXT,
        budget INTEGER DEFAULT 0,
        manager_id INTEGER,
        project_category_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Assistances table
    await db.execute('''
      CREATE TABLE assistances (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        deliver_date TEXT,
        notes TEXT,
        person_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // =============================================
    // ANNOUNCEMENTS FEATURE
    // =============================================
    await _createAnnouncementsTable(db);

    // =============================================
    // SYNC TABLES
    // =============================================

    // Sync log table for tracking sync history
    await db.execute('''
      CREATE TABLE sync_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sync_type TEXT NOT NULL,
        started_at TEXT NOT NULL,
        completed_at TEXT,
        status TEXT NOT NULL,
        records_uploaded INTEGER DEFAULT 0,
        records_downloaded INTEGER DEFAULT 0,
        error_message TEXT
      )
    ''');

    // Idempotent sync operations table for retry safety
    await db.execute('''
      CREATE TABLE sync_operations (
        operation_id TEXT PRIMARY KEY,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        operation_type TEXT NOT NULL,
        payload TEXT NOT NULL,
        priority INTEGER DEFAULT 3,
        status TEXT DEFAULT 'pending',
        created_at TEXT NOT NULL,
        attempt_count INTEGER DEFAULT 0,
        last_attempt_at TEXT,
        next_retry_at TEXT,
        last_error TEXT,
        completed_at TEXT
      )
    ''');

    // Manual conflict resolution queue
    await db.execute('''
      CREATE TABLE manual_conflict_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_id INTEGER NOT NULL,
        local_record TEXT NOT NULL,
        server_record TEXT NOT NULL,
        detected_at TEXT NOT NULL,
        status TEXT DEFAULT 'pending_manual_resolution',
        resolved_at TEXT,
        user_resolution TEXT
      )
    ''');

    // Conflict resolution log for auditing
    await db.execute('''
      CREATE TABLE conflict_resolution_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conflict_id INTEGER NOT NULL,
        entity_type TEXT NOT NULL,
        entity_id INTEGER NOT NULL,
        strategy_used TEXT NOT NULL,
        resolution_success INTEGER DEFAULT 0,
        resolved_at TEXT NOT NULL,
        merge_details TEXT
      )
    ''');

    // Field-level conflicts for detailed tracking
    await db.execute('''
      CREATE TABLE field_conflicts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conflict_id INTEGER NOT NULL,
        field_name TEXT NOT NULL,
        local_value TEXT,
        server_value TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Sync performance metrics for machine learning
    await db.execute('''
      CREATE TABLE sync_performance_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        success INTEGER DEFAULT 0,
        duration_ms INTEGER DEFAULT 0,
        uploaded_count INTEGER DEFAULT 0,
        downloaded_count INTEGER DEFAULT 0,
        network_quality REAL DEFAULT 0.0,
        battery_level INTEGER DEFAULT 0,
        was_charging INTEGER DEFAULT 0,
        device_active INTEGER DEFAULT 0
      )
    ''');

    // Create all indexes
    await _createAllIndexes(db);
  }

  /// Create optimized indexes for query performance
  Future<void> _createAllIndexes(Database db) async {
    // =============================================
    // RESIDENT INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residents_sync ON residents(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residents_unit ON residents(unit_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residents_deleted ON residents(deleted_at)',
    );

    // =============================================
    // ISSUE INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_status ON issues(status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_priority ON issues(priority)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_assigned_to ON issues(assigned_to)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_neighbourhood ON issues(neighbourhood_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_created_at ON issues(created_at DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_status_priority ON issues(status, priority DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_sync ON issues(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_deleted ON issues(deleted_at)',
    );

    // =============================================
    // PERSON INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_persons_sync ON persons(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_persons_deleted ON persons(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_persons_name ON persons(first_name, last_name)',
    );

    // =============================================
    // RESIDENTIAL HIERARCHY INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residential_units_sync ON residential_units(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residential_units_deleted ON residential_units(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residential_neighborhoods_sync ON residential_neighborhoods(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residential_neighborhoods_deleted ON residential_neighborhoods(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residential_blocks_sync ON residential_blocks(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residential_blocks_deleted ON residential_blocks(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residential_blocks_unit ON residential_blocks(unit_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_residential_blocks_neighbourhood ON residential_blocks(neighbourhood_id)',
    );

    // =============================================
    // FAMILY INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_families_sync ON families(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_families_deleted ON families(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_families_block ON families(block_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_families_category ON families(family_category_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_family_members_family ON family_members(family_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_family_members_person ON family_members(person_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_family_members_sync ON family_members(sync_status)',
    );

    // =============================================
    // TEAM INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_teams_sync ON teams(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_teams_deleted ON teams(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_team_members_team ON team_members(team_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_team_members_person ON team_members(person_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_team_members_sync ON team_members(sync_status)',
    );

    // =============================================
    // CONFLICT INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_conflicts_sync ON conflicts(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_conflicts_deleted ON conflicts(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_conflicts_type ON conflicts(conflict_type_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_conflicts_resolved ON conflicts(is_resolved)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_conflicts_first_party ON conflicts(first_party_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_conflicts_second_party ON conflicts(second_party_id)',
    );

    // =============================================
    // GOVERNMENT INSTITUTION INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_govt_institutions_sync ON government_institutions(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_govt_institutions_deleted ON government_institutions(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_govt_contacts_institution ON government_institution_contacts(institution_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_govt_contacts_sync ON government_institution_contacts(sync_status)',
    );

    // =============================================
    // PROJECT & ASSISTANCE INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_projects_sync ON projects(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_projects_deleted ON projects(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(project_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_projects_manager ON projects(manager_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_projects_category ON projects(project_category_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_assistances_sync ON assistances(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_assistances_deleted ON assistances(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_assistances_person ON assistances(person_id)',
    );

    // =============================================
    // ANNOUNCEMENT INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_announcements_sync ON announcements(sync_status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_announcements_deleted ON announcements(deleted_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_announcements_published ON announcements(is_published)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_announcements_neighbourhood ON announcements(neighbourhood_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_announcements_created_at ON announcements(created_at DESC)',
    );

    // =============================================
    // SYNC OPERATION INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_ops_entity ON sync_operations(entity_type, entity_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_ops_pending ON sync_operations(completed_at) WHERE completed_at IS NULL',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_ops_status ON sync_operations(status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_ops_priority ON sync_operations(priority, created_at)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_ops_retry ON sync_operations(next_retry_at) WHERE next_retry_at IS NOT NULL',
    );

    // =============================================
    // CONFLICT RESOLUTION INDEXES
    // =============================================
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_manual_conflicts_status ON manual_conflict_queue(status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_manual_conflicts_entity ON manual_conflict_queue(entity_type, entity_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_conflict_log_entity ON conflict_resolution_log(entity_type, entity_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_field_conflicts_conflict ON field_conflicts(conflict_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sync_performance_timestamp ON sync_performance_log(timestamp DESC)',
    );
  }

  /// Create server_id indexes for efficient sync lookups
  Future<void> _createServerIdIndexes(Database db) async {
    // =============================================
    // SERVER_ID INDEXES FOR SYNC LOOKUPS
    // =============================================
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_residents_server_id ON residents(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_issues_server_id ON issues(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_persons_server_id ON persons(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_residential_units_server_id ON residential_units(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_residential_neighbourhoods_server_id ON residential_neighbourhoods(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_residential_blocks_server_id ON residential_blocks(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_families_server_id ON families(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_family_categories_server_id ON family_categories(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_family_member_roles_server_id ON family_member_roles(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_family_members_server_id ON family_members(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_teams_server_id ON teams(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_team_roles_server_id ON team_roles(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_team_members_server_id ON team_members(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_conflicts_server_id ON conflicts(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_conflict_types_server_id ON conflict_types(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_govt_institutions_server_id ON government_institutions(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_govt_contacts_server_id ON government_institution_contacts(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_managers_server_id ON managers(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_project_categories_server_id ON project_categories(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_projects_server_id ON projects(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_assistances_server_id ON assistances(server_id) WHERE server_id IS NOT NULL',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_announcements_server_id ON announcements(server_id) WHERE server_id IS NOT NULL',
    );
  }

  /// Create tables added in version 3
  Future<void> _createV3Tables(Database db) async {
    // Persons table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS persons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        second_name TEXT,
        third_name TEXT,
        last_name TEXT NOT NULL,
        date_of_birth TEXT,
        phone_number TEXT,
        image TEXT,
        gender TEXT,
        blood_type TEXT,
        occupation_status TEXT,
        marital_status TEXT,
        job TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Residential Units table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS residential_units (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        blocks_count INTEGER DEFAULT 0,
        unit_manager_id INTEGER,
        unit_manager_name TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Residential Neighborhoods table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS residential_neighborhoods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        units_count INTEGER DEFAULT 0,
        blocks_count INTEGER DEFAULT 0,
        manager_id INTEGER,
        manager_name TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Residential Blocks table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS residential_blocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        families_count INTEGER DEFAULT 0,
        manager_id INTEGER,
        manager_name TEXT,
        unit_id INTEGER,
        neighbourhood_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Family Categories table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS family_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Families table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS families (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT,
        family_category_id INTEGER,
        family_notes TEXT,
        block_id INTEGER,
        family_head_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Family Member Roles table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS family_member_roles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        role_name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Family Members junction table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS family_members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        family_id INTEGER NOT NULL,
        person_id INTEGER NOT NULL,
        role_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Teams table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS teams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Team Roles table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS team_roles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Team Members junction table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS team_members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        team_id INTEGER NOT NULL,
        person_id INTEGER NOT NULL,
        person_name TEXT,
        date_of_join TEXT,
        team_role_id INTEGER,
        team_role_name TEXT,
        team_name TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Conflict Types table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS conflict_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Conflicts table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS conflicts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        conflict_type_id INTEGER,
        conflict_type_name TEXT,
        manager_name TEXT,
        first_party_id INTEGER,
        first_party_name TEXT,
        second_party_id INTEGER,
        second_party_name TEXT,
        notes TEXT,
        image_url TEXT,
        session_date TEXT,
        is_resolved INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Government Institutions table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS government_institutions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Government Institution Contacts table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS government_institution_contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        institution_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        job TEXT,
        phone TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Managers table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS managers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Project Categories table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS project_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Projects table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        start_date TEXT,
        end_date TEXT,
        project_status TEXT,
        project_priority TEXT,
        budget INTEGER DEFAULT 0,
        manager_id INTEGER,
        project_category_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Assistances table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS assistances (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        deliver_date TEXT,
        notes TEXT,
        person_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');

    // Announcements table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS announcements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT,
        category TEXT,
        priority TEXT DEFAULT 'normal',
        is_published INTEGER DEFAULT 0,
        published_at TEXT,
        expires_at TEXT,
        author_id INTEGER,
        target_audience TEXT,
        neighbourhood_id INTEGER,
        block_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id INTEGER,
        deleted_at TEXT
      )
    ''');
  }

  /// Close database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Clear all data (for logout/reset)
  Future<void> clearAllData() async {
    final db = await database;
    // Core entities
    await db.delete('residents');
    await db.delete('issues');
    // People
    await db.delete('persons');
    // Residential hierarchy
    await db.delete('residential_units');
    await db.delete('residential_neighborhoods');
    await db.delete('residential_blocks');
    // Families
    await db.delete('family_categories');
    await db.delete('families');
    await db.delete('family_member_roles');
    await db.delete('family_members');
    // Teams
    await db.delete('teams');
    await db.delete('team_roles');
    await db.delete('team_members');
    // Conflicts
    await db.delete('conflict_types');
    await db.delete('conflicts');
    // Government institutions
    await db.delete('government_institutions');
    await db.delete('government_institution_contacts');
    // Assistances & Projects
    await db.delete('managers');
    await db.delete('project_categories');
    await db.delete('projects');
    await db.delete('assistances');
    // Announcements
    await db.delete('announcements');
    // Sync
    await db.delete('sync_log');
    await db.delete('sync_operations');
  }

  /// Delete database file completely
  Future<void> deleteDatabase() async {
    await close();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
    await _secureStorage.delete(key: _keyAlias);
  }
}
