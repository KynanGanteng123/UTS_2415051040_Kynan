import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/motor_model.dart';
import '../models/rental_booking_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal() {
    _ensureFactory();
  }

  static void _ensureFactory() {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      try {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      } catch (_) {}
    }
  }

  static Database? _database;
  static Future<Database?>? _initFuture;
  static const String tableName = 'rental_bookings';
  static const String motorTableName = 'motors';
  static const String dbName = 'motorent_database.db';

  // In-memory fallback untuk browser Web atau jika SQLite FFI tidak aktif
  static final List<MotorModel> _fallbackMotors = [];
  static final List<RentalBookingModel> _fallbackBookings = [
    RentalBookingModel(
      id: 1,
      studentId: '2415051040',
      motorId: 1,
      motorName: 'Honda Vario 160 CBS',
      customerName: 'Kynan (Demo)',
      rentalDays: 2,
      pricePerDay: 85000,
      totalPrice: 170000,
      type: 'Matic',
      note: 'Sewa untuk survey lokasi kuliah lapangan di Pantai Lovina Singaraja.',
      rating: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    ),
  ];

  Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null) return _database;
    _initFuture ??= _initDatabase();
    _database = await _initFuture;
    return _database;
  }

  Future<Database?> _initDatabase() async {
    if (kIsWeb) return null;

    try {
      _ensureFactory();

      final String dbPath = await getDatabasesPath();
      final String path = join(dbPath, dbName);

      final db = await openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );

      await _ensureTables(db);
      return db;
    } catch (e) {
      debugPrint('SQLite database initialization fallback: $e');
      return null;
    }
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
    try {
      final db = await database;
      if (db != null) {
        return await db.insert(
          tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      debugPrint('Error inserting booking in SQLite: $e');
    }

    final newId = item.id ??
        (_fallbackBookings.isEmpty
            ? 1
            : _fallbackBookings.map((b) => b.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    final saved = item.copyWith(id: newId);
    _fallbackBookings.removeWhere((b) => b.id == newId);
    _fallbackBookings.insert(0, saved);
    return newId;
  }

  /// Read: Mengambil semua data rental
  Future<List<RentalBookingModel>> getAllBookings() async {
    try {
      final db = await database;
      if (db != null) {
        final List<Map<String, dynamic>> maps = await db.query(
          tableName,
          orderBy: 'id DESC',
        );
        return maps.map((map) => RentalBookingModel.fromMap(map)).toList();
      }
    } catch (e) {
      debugPrint('Error getting bookings from SQLite: $e');
    }

    return List<RentalBookingModel>.from(_fallbackBookings);
  }

  /// Update: Memperbarui data rental
  Future<int> updateBooking(RentalBookingModel item) async {
    try {
      final db = await database;
      if (db != null && item.id != null) {
        return await db.update(
          tableName,
          item.toMap(),
          where: 'id = ?',
          whereArgs: [item.id],
        );
      }
    } catch (e) {
      debugPrint('Error updating booking in SQLite: $e');
    }

    final index = _fallbackBookings.indexWhere((b) => b.id == item.id);
    if (index != -1) {
      _fallbackBookings[index] = item;
      return 1;
    }
    return 0;
  }

  /// Delete: Menghapus data rental berdasarkan ID
  Future<int> deleteBooking(int id) async {
    try {
      final db = await database;
      if (db != null) {
        return await db.delete(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    } catch (e) {
      debugPrint('Error deleting booking from SQLite: $e');
    }

    _fallbackBookings.removeWhere((b) => b.id == id);
    return 1;
  }

  /// Memeriksa apakah motor dengan ID tertentu sedang disewa
  Future<bool> isMotorBooked(int motorId) async {
    try {
      final db = await database;
      if (db != null) {
        final List<Map<String, dynamic>> result = await db.query(
          tableName,
          where: 'motor_id = ?',
          whereArgs: [motorId],
          limit: 1,
        );
        return result.isNotEmpty;
      }
    } catch (e) {
      debugPrint('Error checking booking in SQLite: $e');
    }

    return _fallbackBookings.any((b) => b.motorId == motorId);
  }

  // ==========================================
  // CRUD OPERASI: KATALOG ARMADA MOTOR
  // ==========================================

  /// Create: Menambahkan unit motor baru ke katalog SQLite / In-Memory
  Future<int> insertMotor(MotorModel motor) async {
    try {
      final db = await database;
      if (db != null) {
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
    } catch (e) {
      debugPrint('Error inserting motor in SQLite: $e');
    }

    final newId = motor.id > 0
        ? motor.id
        : (_fallbackMotors.isEmpty
            ? 1
            : _fallbackMotors.map((m) => m.id).reduce((a, b) => a > b ? a : b) + 1);
    final saved = motor.copyWith(id: newId);
    _fallbackMotors.removeWhere((m) => m.id == newId);
    _fallbackMotors.insert(0, saved);
    return newId;
  }

  /// Read: Mengambil seluruh unit motor dari SQLite / In-Memory
  Future<List<MotorModel>> getAllMotors() async {
    try {
      final db = await database;
      if (db != null) {
        final List<Map<String, dynamic>> maps = await db.query(
          motorTableName,
          orderBy: 'id DESC',
        );
        return maps.map((map) => MotorModel.fromMap(map)).toList();
      }
    } catch (e) {
      debugPrint('Error getting motors from SQLite: $e');
    }

    return List<MotorModel>.from(_fallbackMotors);
  }

  /// Update: Memperbarui data kolom unit motor di SQLite / In-Memory
  Future<int> updateMotor(MotorModel motor) async {
    try {
      final db = await database;
      if (db != null) {
        return await db.update(
          motorTableName,
          motor.toMap(),
          where: 'id = ?',
          whereArgs: [motor.id],
        );
      }
    } catch (e) {
      debugPrint('Error updating motor in SQLite: $e');
    }

    final index = _fallbackMotors.indexWhere((m) => m.id == motor.id);
    if (index != -1) {
      _fallbackMotors[index] = motor;
      return 1;
    } else {
      _fallbackMotors.add(motor);
      return 1;
    }
  }

  /// Delete: Menghapus unit motor dari katalog SQLite / In-Memory
  Future<int> deleteMotor(int id) async {
    try {
      final db = await database;
      if (db != null) {
        return await db.delete(
          motorTableName,
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    } catch (e) {
      debugPrint('Error deleting motor from SQLite: $e');
    }

    _fallbackMotors.removeWhere((m) => m.id == id);
    return 1;
  }
}
