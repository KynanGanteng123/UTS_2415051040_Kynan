import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/motor_model.dart';
import '../models/rental_booking_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  static const String tableName = 'rental_bookings';
  static const String motorTableName = 'motors';
  static const String dbName = 'motorent_database.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, dbName);

    final db = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    // Memastikan kedua tabel selalu ada
    await _ensureTables(db);

    return db;
  }

  Future<void> _ensureTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id TEXT NOT NULL,
        motor_id INTEGER NOT NULL,
        motor_name TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        rental_days INTEGER NOT NULL,
        price_per_day INTEGER NOT NULL,
        total_price INTEGER NOT NULL,
        type TEXT NOT NULL,
        note TEXT NOT NULL,
        rating REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $motorTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        type TEXT NOT NULL,
        cc INTEGER NOT NULL,
        price_per_day INTEGER NOT NULL,
        transmission TEXT NOT NULL,
        image_url TEXT NOT NULL,
        rating REAL NOT NULL,
        is_available INTEGER NOT NULL,
        description TEXT NOT NULL,
        facilities TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onCreate(Database db, int version) async {
    await _ensureTables(db);

    // Data awal demonstrasi sewa motor
    await db.insert(tableName, {
      'student_id': '2415051040',
      'motor_id': 1,
      'motor_name': 'Honda Vario 160 CBS',
      'customer_name': 'Kynan (Demo)',
      'rental_days': 2,
      'price_per_day': 85000,
      'total_price': 170000,
      'type': 'Matic',
      'note': 'Sewa untuk survey lokasi kuliah lapangan di Pantai Lovina Singaraja.',
      'rating': 5.0,
      'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _ensureTables(db);
    }
  }

  // ==========================================
  // CRUD OPERASI: RENTAL BOOKINGS
  // ==========================================

  /// Create: Menambahkan pesanan rental baru
  Future<int> insertBooking(RentalBookingModel item) async {
    final db = await database;
    return await db.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Read: Mengambil semua data rental
  Future<List<RentalBookingModel>> getAllBookings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'id DESC',
    );
    return maps.map((map) => RentalBookingModel.fromMap(map)).toList();
  }

  /// Update: Memperbarui data rental
  Future<int> updateBooking(RentalBookingModel item) async {
    final db = await database;
    if (item.id == null) return 0;
    return await db.update(
      tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  /// Delete: Menghapus data rental berdasarkan ID
  Future<int> deleteBooking(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Memeriksa apakah motor dengan ID tertentu sedang disewa
  Future<bool> isMotorBooked(int motorId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'motor_id = ?',
      whereArgs: [motorId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // ==========================================
  // CRUD OPERASI: KATALOG ARMADA MOTOR
  // ==========================================

  /// Create: Menambahkan unit motor baru ke katalog SQLite
  Future<int> insertMotor(MotorModel motor) async {
    final db = await database;
    final map = motor.toMap();
    if (motor.id <= 0) {
      map.remove('id');
    }
    return await db.insert(
      motorTableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Read: Mengambil seluruh unit motor dari SQLite
  Future<List<MotorModel>> getAllMotors() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      motorTableName,
      orderBy: 'id DESC',
    );
    return maps.map((map) => MotorModel.fromMap(map)).toList();
  }

  /// Update: Memperbarui data kolom unit motor di SQLite
  Future<int> updateMotor(MotorModel motor) async {
    final db = await database;
    return await db.update(
      motorTableName,
      motor.toMap(),
      where: 'id = ?',
      whereArgs: [motor.id],
    );
  }

  /// Delete: Menghapus unit motor dari katalog SQLite
  Future<int> deleteMotor(int id) async {
    final db = await database;
    return await db.delete(
      motorTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
