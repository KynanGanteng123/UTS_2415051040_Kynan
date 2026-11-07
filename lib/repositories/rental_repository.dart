import '../models/rental_booking_model.dart';
import '../services/database_service.dart';

class RentalRepository {
  final DatabaseService _databaseService;

  RentalRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  Future<List<RentalBookingModel>> getBookings() async {
    return await _databaseService.getAllBookings();
  }

  Future<int> addBooking(RentalBookingModel item) async {
    return await _databaseService.insertBooking(item);
  }

  Future<int> updateBooking(RentalBookingModel item) async {
    return await _databaseService.updateBooking(item);
  }

  Future<int> deleteBooking(int id) async {
    return await _databaseService.deleteBooking(id);
  }

  Future<bool> checkIsBooked(int motorId) async {
    return await _databaseService.isMotorBooked(motorId);
  }
}
