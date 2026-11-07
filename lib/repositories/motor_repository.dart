import '../models/motor_model.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class MotorRepository {
  final ApiService _apiService;
  final DatabaseService _databaseService;

  MotorRepository({
    ApiService? apiService,
    DatabaseService? databaseService,
  })  : _apiService = apiService ?? ApiService(),
        _databaseService = databaseService ?? DatabaseService();

  /// Mengambil daftar motor rental:
  /// Memeriksa SQLite terlebih dahulu, jika baru pertama kali,
  /// menyinkronkan data dari REST API publik (GET) ke SQLite.
  Future<List<MotorModel>> getMotors() async {
    var dbMotors = await _databaseService.getAllMotors();

    if (dbMotors.isEmpty) {
      try {
        final apiMotors = await _apiService.fetchMotors();
        for (final motor in apiMotors) {
          await _databaseService.insertMotor(motor);
        }
        dbMotors = await _databaseService.getAllMotors();
      } catch (_) {
        // Fallback jika terjadi kendala pada database
      }
    }

    if (dbMotors.isEmpty) {
      return await _apiService.fetchMotors();
    }

    return dbMotors;
  }

  /// Menambahkan motor baru ke database SQLite
  Future<MotorModel> addMotor(MotorModel motor) async {
    final newId = await _databaseService.insertMotor(motor);
    return motor.copyWith(id: newId);
  }

  /// Memperbarui kolom data motor di database SQLite
  Future<bool> updateMotor(MotorModel motor) async {
    final count = await _databaseService.updateMotor(motor);
    return count > 0;
  }

  /// Menghapus motor dari database SQLite
  Future<bool> deleteMotor(int id) async {
    final count = await _databaseService.deleteMotor(id);
    return count > 0;
  }
}
