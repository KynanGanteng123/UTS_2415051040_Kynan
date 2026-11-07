import 'package:flutter/foundation.dart';
import '../models/motor_model.dart';
import '../repositories/motor_repository.dart';

class MotorProvider with ChangeNotifier {
  final MotorRepository _repository;

  MotorProvider({MotorRepository? repository})
      : _repository = repository ?? MotorRepository();

  List<MotorModel> _motors = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  List<MotorModel> get motors => _motors;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<MotorModel> get filteredMotors {
    return _motors.where((m) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          m.type.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.facilities.any(
              (f) => f.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<MotorModel> get recommendedMotors {
    return _motors.where((m) => m.rating >= 4.7).take(4).toList();
  }

  /// Memuat daftar motor dari database SQLite / REST API
  Future<void> fetchMotors() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _motors = await _repository.getMotors();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat katalog motor rental: $e';
      notifyListeners();
    }
  }

  /// Menambahkan unit motor baru ke sistem (Create)
  Future<bool> addMotor(MotorModel motor) async {
    try {
      final savedMotor = await _repository.addMotor(motor);
      _motors.insert(0, savedMotor);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambahkan motor baru: $e';
      notifyListeners();
      return false;
    }
  }

  /// Memperbarui informasi unit motor (Update)
  Future<bool> updateMotor(MotorModel motor) async {
    try {
      final success = await _repository.updateMotor(motor);
      if (success) {
        final index = _motors.indexWhere((m) => m.id == motor.id);
        if (index != -1) {
          _motors[index] = motor;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui data motor: $e';
      notifyListeners();
      return false;
    }
  }

  /// Menghapus unit motor dari katalog (Delete)
  Future<bool> deleteMotor(int id) async {
    try {
      final success = await _repository.deleteMotor(id);
      if (success) {
        _motors.removeWhere((m) => m.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Gagal menghapus motor: $e';
      notifyListeners();
      return false;
    }
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _selectedCategory = 'Semua';
    notifyListeners();
  }
}
