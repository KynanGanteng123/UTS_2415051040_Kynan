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
  /// Memeriksa SQLite/Local Store terlebih dahulu. Jika kosong,
  /// menyinkronkan data dari REST API publik (GET) lalu menyimpannya.
  Future<List<MotorModel>> getMotors() async {
    try {
      var dbMotors = await _databaseService.getAllMotors();

      if (dbMotors.isEmpty) {
        try {
          final apiMotors = await _apiService.fetchMotors();
          for (final motor in apiMotors) {
            await _databaseService.insertMotor(motor);
          }
          dbMotors = await _databaseService.getAllMotors();
          if (dbMotors.isNotEmpty) return dbMotors;
          return apiMotors;
        } catch (_) {
          return await _apiService.fetchMotors();
        }
      }

      return dbMotors;
    } catch (_) {
      // Fallback mutlak ke API jika terjadi kendala
      return await _apiService.fetchMotors();
    }
  }

  /// Menambahkan motor baru ke sistem (SQLite / Local Store)
  Future<MotorModel> addMotor(MotorModel motor) async {
    final newId = await _databaseService.insertMotor(motor);
    return motor.copyWith(id: newId);
  }

  /// Memperbarui kolom data motor
  Future<bool> updateMotor(MotorModel motor) async {
    final count = await _databaseService.updateMotor(motor);
    return count > 0;
  }

  /// Menghapus motor dari katalog
  Future<bool> deleteMotor(int id) async {
    final count = await _databaseService.deleteMotor(id);
    return count > 0;
  }
}
