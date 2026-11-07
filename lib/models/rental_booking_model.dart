class RentalBookingModel {
  final int? id;
  final String studentId; // Kynan NIM: '2415051040'
  final int motorId;
  final String motorName;
  final String customerName;
  final int rentalDays;
  final int pricePerDay;
  final int totalPrice;
  final String type;
  final String note;
  final double rating;
  final String createdAt;

  RentalBookingModel({
    this.id,
    required this.studentId,
    required this.motorId,
    required this.motorName,
    required this.customerName,
    required this.rentalDays,
    required this.pricePerDay,
    required this.totalPrice,
    required this.type,
    required this.note,
    required this.rating,
    required this.createdAt,
  });

  factory RentalBookingModel.fromMap(Map<String, dynamic> map) {
    return RentalBookingModel(
      id: map['id'] as int?,
      studentId: map['student_id'] as String? ?? '2415051040',
      motorId: map['motor_id'] as int? ?? 0,
      motorName: map['motor_name'] as String? ?? '',
      customerName: map['customer_name'] as String? ?? '',
      rentalDays: map['rental_days'] as int? ?? 1,
      pricePerDay: map['price_per_day'] as int? ?? 0,
      totalPrice: map['total_price'] as int? ?? 0,
      type: map['type'] as String? ?? 'Matic',
      note: map['note'] as String? ?? '',
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 5.0,
      createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'student_id': studentId,
      'motor_id': motorId,
      'motor_name': motorName,
      'customer_name': customerName,
      'rental_days': rentalDays,
      'price_per_day': pricePerDay,
      'total_price': totalPrice,
      'type': type,
      'note': note,
      'rating': rating,
      'created_at': createdAt,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  RentalBookingModel copyWith({
    int? id,
    String? studentId,
    int? motorId,
    String? motorName,
    String? customerName,
    int? rentalDays,
    int? pricePerDay,
    int? totalPrice,
    String? type,
    String? note,
    double? rating,
    String? createdAt,
  }) {
    return RentalBookingModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      motorId: motorId ?? this.motorId,
      motorName: motorName ?? this.motorName,
      customerName: customerName ?? this.customerName,
      rentalDays: rentalDays ?? this.rentalDays,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      totalPrice: totalPrice ?? this.totalPrice,
      type: type ?? this.type,
      note: note ?? this.note,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get formattedTotal {
    final chars = totalPrice.toString().split('').reversed.toList();
    final parts = <String>[];
    for (int i = 0; i < chars.length; i += 3) {
      final end = (i + 3 < chars.length) ? i + 3 : chars.length;
      parts.add(chars.sublist(i, end).reversed.join());
    }
    return 'Rp ${parts.reversed.join('.')}';
  }

  String get formattedPricePerDay {
    final chars = pricePerDay.toString().split('').reversed.toList();
    final parts = <String>[];
    for (int i = 0; i < chars.length; i += 3) {
      final end = (i + 3 < chars.length) ? i + 3 : chars.length;
      parts.add(chars.sublist(i, end).reversed.join());
    }
    return 'Rp ${parts.reversed.join('.')}/hari';
  }
}
