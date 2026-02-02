import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite_sqlcipher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';

/// Core encrypted database service for offline-first storage
/// Uses SQLCipher for AES-256 encryption at rest
class DatabaseService {
  static Database? _database;
  static const String _dbName = 'smart_neighbourhood.db';
  static const int _dbVersion = 1;

  // Secure storage for encryption key
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _keyAlias = 'db_encryption_key';

  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  /// Get or create the encrypted database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the encrypted SQLite database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    // Get or generate encryption key
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

  /// Create all tables on first database creation
  Future<void> _onCreate(Database db, int version) async {
    // Residents table
    await db.execute('''
      CREATE TABLE residents (
        id TEXT PRIMARY KEY,
        national_id TEXT NOT NULL,
        full_name TEXT NOT NULL,
        phone TEXT,
        unit_id TEXT,
        block_id TEXT,
        neighbourhood_id TEXT,
        status TEXT DEFAULT 'active',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        server_id TEXT,
        deleted_at TEXT
      )
    ''');

    // Issues/Complaints table
    await db.execute('''
      CREATE TABLE issues (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        priority TEXT DEFAULT 'medium',
        status TEXT DEFAULT 'open',
        reporter_id TEXT,
        assigned_to TEXT,
        unit_id TEXT,
        block_id TEXT,
        neighbourhood_id TEXT,
        resolution_notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        resolved_at TEXT,
        sync_status TEXT DEFAULT 'pending',
        server_id TEXT,
        deleted_at TEXT
      )
    ''');

    // Sync log table for tracking sync history
    await db.execute('''
      CREATE TABLE sync_log (
        id TEXT PRIMARY KEY,
        sync_type TEXT NOT NULL,
        started_at TEXT NOT NULL,
        completed_at TEXT,
        status TEXT NOT NULL,
        records_uploaded INTEGER DEFAULT 0,
        records_downloaded INTEGER DEFAULT 0,
        error_message TEXT
      )
    ''');

    // Create indexes for common queries
    await db.execute(
      'CREATE INDEX idx_residents_sync ON residents(sync_status)',
    );
    await db.execute('CREATE INDEX idx_residents_unit ON residents(unit_id)');
    await db.execute('CREATE INDEX idx_issues_sync ON issues(sync_status)');
    await db.execute('CREATE INDEX idx_issues_status ON issues(status)');
  }

  /// Handle database migrations
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add migration logic here for future versions
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE residents ADD COLUMN email TEXT');
    // }
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
    await db.delete('residents');
    await db.delete('issues');
    await db.delete('sync_log');
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
