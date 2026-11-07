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

  factory MotorModel.fromMap(Map<String, dynamic> map) {
    return MotorModel(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      brand: map['brand'] as String? ?? '',
      type: map['type'] as String? ?? 'Matic',
      cc: map['cc'] as int? ?? 125,
      pricePerDay: map['price_per_day'] as int? ?? 0,
      transmission: map['transmission'] as String? ?? 'Otomatis',
      imageUrl: map['image_url'] as String? ?? '',
      rating:
          (map['rating'] is num) ? (map['rating'] as num).toDouble() : 4.5,
      isAvailable: (map['is_available'] is int)
          ? (map['is_available'] == 1)
          : (map['is_available'] as bool? ?? true),
      description: map['description'] as String? ?? '',
      facilities: (map['facilities'] != null &&
              map['facilities'].toString().isNotEmpty)
          ? map['facilities']
              .toString()
              .split(',')
              .map((e) => e.trim())
              .toList()
          : ['2 Helm SNI', 'Jas Hujan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'type': type,
      'cc': cc,
      'price_per_day': pricePerDay,
      'transmission': transmission,
      'image_url': imageUrl,
      'rating': rating,
      'is_available': isAvailable ? 1 : 0,
      'description': description,
      'facilities': facilities.join(', '),
    };
  }

  MotorModel copyWith({
    int? id,
    String? name,
    String? brand,
    String? type,
    int? cc,
    int? pricePerDay,
    String? transmission,
    String? imageUrl,
    double? rating,
    bool? isAvailable,
    String? description,
    List<String>? facilities,
  }) {
    return MotorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      type: type ?? this.type,
      cc: cc ?? this.cc,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      transmission: transmission ?? this.transmission,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      isAvailable: isAvailable ?? this.isAvailable,
      description: description ?? this.description,
      facilities: facilities ?? this.facilities,
    );
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
