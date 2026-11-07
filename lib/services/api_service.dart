import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/motor_model.dart';

class ApiService {
  // REST API Endpoint publik hosted di repository GitHub MotoRent Kynan
  static const String apiUrl =
      'https://raw.githubusercontent.com/KynanGanteng123/UTS_2415051040_Kynan/main/assets/data/motor_api.json';

  static const Duration timeoutDuration = Duration(seconds: 5);

  /// Mengambil daftar armada motor dari REST API (GET)
  /// Dilengkapi fallback otomatis ke local asset jika offline / server timeout
  Future<List<MotorModel>> fetchMotors() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((item) => MotorModel.fromJson(item)).toList();
      } else {
        return await _loadFromLocalAsset();
      }
    } catch (_) {
      return await _loadFromLocalAsset();
    }
  }

  /// Memuat dataset motor dari asset lokal
  Future<List<MotorModel>> _loadFromLocalAsset() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/motor_api.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => MotorModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Gagal memuat katalog motor rental: $e');
    }
  }
}
