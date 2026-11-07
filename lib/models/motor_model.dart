class MotorModel {
  final int id;
  final String name;
  final String brand;
  final String type; // 'Matic', 'Sport', 'Manual', 'Retro'
  final int cc;
  final int pricePerDay;
  final String transmission;
  final String imageUrl;
  final double rating;
  final bool isAvailable;
  final String description;
  final List<String> facilities;

  MotorModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.cc,
    required this.pricePerDay,
    required this.transmission,
    required this.imageUrl,
    required this.rating,
    required this.isAvailable,
    required this.description,
    required this.facilities,
  });

  factory MotorModel.fromJson(Map<String, dynamic> json) {
    return MotorModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      type: json['type'] as String? ?? 'Matic',
      cc: json['cc'] as int? ?? 125,
      pricePerDay: json['pricePerDay'] as int? ?? 0,
      transmission: json['transmission'] as String? ?? 'Otomatis',
      imageUrl: json['imageUrl'] as String? ?? '',
      rating:
          (json['rating'] is num) ? (json['rating'] as num).toDouble() : 4.5,
      isAvailable: json['isAvailable'] as bool? ?? true,
      description: json['description'] as String? ?? '',
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'type': type,
      'cc': cc,
      'pricePerDay': pricePerDay,
      'transmission': transmission,
      'imageUrl': imageUrl,
      'rating': rating,
      'isAvailable': isAvailable,
      'description': description,
      'facilities': facilities,
    };
  }

  String get formattedPrice {
    final chars = pricePerDay.toString().split('').reversed.toList();
    final parts = <String>[];
    for (int i = 0; i < chars.length; i += 3) {
      final end = (i + 3 < chars.length) ? i + 3 : chars.length;
      parts.add(chars.sublist(i, end).reversed.join());
    }
    return 'Rp ${parts.reversed.join('.')}/hari';
  }
}
