import 'package:flutter/foundation.dart';
import '../models/motor_model.dart';
import '../models/rental_booking_model.dart';
import '../repositories/rental_repository.dart';

class RentalProvider with ChangeNotifier {
  final RentalRepository _repository;

  RentalProvider({RentalRepository? repository})
      : _repository = repository ?? RentalRepository();

  List<RentalBookingModel> _bookings = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final Set<int> _bookedMotorIds = {};

  List<RentalBookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get totalBookingsCount => _bookings.length;

  bool isBooked(int motorId) => _bookedMotorIds.contains(motorId);

  Future<void> loadBookings() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _bookings = await _repository.getBookings();
      _bookedMotorIds.clear();
      for (final item in _bookings) {
        _bookedMotorIds.add(item.motorId);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat riwayat booking database: $e';
      notifyListeners();
    }
  }

  Future<bool> createBooking(RentalBookingModel item) async {
    try {
      final insertedId = await _repository.addBooking(item);
      if (insertedId > 0) {
        await loadBookings();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan booking rental: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> editBooking(RentalBookingModel item) async {
    try {
      final affected = await _repository.updateBooking(item);
      if (affected > 0) {
        await loadBookings();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui data rental: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeBooking(int id, int? motorId) async {
    try {
      final affected = await _repository.deleteBooking(id);
      if (affected > 0) {
        if (motorId != null) {
          _bookedMotorIds.remove(motorId);
        }
        await loadBookings();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menghapus data rental: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleBooking(MotorModel motor,
      {String customerName = 'Kynan',
      int rentalDays = 1,
      String note = '',
      double rating = 5.0}) async {
    if (isBooked(motor.id)) {
      final item = _bookings.firstWhere(
        (b) => b.motorId == motor.id,
        orElse: () => RentalBookingModel(
          id: -1,
          studentId: '2415051040',
          motorId: motor.id,
          motorName: motor.name,
          customerName: customerName,
          rentalDays: 1,
          pricePerDay: motor.pricePerDay,
          totalPrice: motor.pricePerDay,
          type: motor.type,
          note: '',
          rating: 5.0,
          createdAt: '',
        ),
      );
      if (item.id != null && item.id! > 0) {
        return await removeBooking(item.id!, motor.id);
      }
      return false;
    } else {
      final newItem = RentalBookingModel(
        studentId: '2415051040',
        motorId: motor.id,
        motorName: motor.name,
        customerName: customerName,
        rentalDays: rentalDays,
        pricePerDay: motor.pricePerDay,
        totalPrice: motor.pricePerDay * rentalDays,
        type: motor.type,
        note: note.isEmpty ? 'Disimpan dari katalog MotoRent.' : note,
        rating: rating,
        createdAt: DateTime.now().toIso8601String(),
      );
      return await createBooking(newItem);
    }
  }
}
