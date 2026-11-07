import '../models/motor_model.dart';
import '../services/api_service.dart';

class MotorRepository {
  final ApiService _apiService;

  MotorRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<MotorModel>> getMotors() async {
    return await _apiService.fetchMotors();
  }
}
