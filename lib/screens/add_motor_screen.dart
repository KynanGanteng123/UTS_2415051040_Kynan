import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/motor_model.dart';
import '../providers/motor_provider.dart';
import '../widgets/rating_stars_widget.dart';
import '../widgets/custom_button_widget.dart';

class AddMotorScreen extends StatefulWidget {
  const AddMotorScreen({super.key});

  @override
  State<AddMotorScreen> createState() => _AddMotorScreenState();
}

class _AddMotorScreenState extends State<AddMotorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _ccController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _facilitiesController =
      TextEditingController(text: '2 Helm SNI, Jas Hujan, Holder HP');
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedType = 'Matic';
  String _selectedTransmission = 'Otomatis';
  bool _isAvailable = true;
  double _rating = 4.8;
  bool _isLoading = false;

  final List<String> _typeOptions = [
    'Matic',
    'Sport',
    'Retro',
    'Bebek',
    'Touring'
  ];

  final List<String> _transmissionOptions = ['Otomatis', 'Manual'];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _ccController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _facilitiesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final cc = int.tryParse(_ccController.text.trim()) ?? 125;
    final price =
        int.tryParse(_priceController.text.replaceAll('.', '').trim()) ?? 80000;

    String imageUrl = _imageUrlController.text.trim();
    if (imageUrl.isEmpty) {
      imageUrl =
          'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?auto=format&fit=crop&w=800&q=80';
    }

    final facilities = _facilitiesController.text
        .split(',')
        .map((f) => f.trim())
        .where((f) => f.isNotEmpty)
        .toList();

    final newMotor = MotorModel(
      id: 0, // Diberikan auto-increment oleh SQLite
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      type: _selectedType,
      cc: cc,
      pricePerDay: price,
      transmission: _selectedTransmission,
      imageUrl: imageUrl,
      rating: _rating,
      isAvailable: _isAvailable,
      description: _descriptionController.text.trim(),
      facilities: facilities.isNotEmpty
          ? facilities
          : ['2 Helm SNI', 'Jas Hujan'],
    );

    final provider = Provider.of<MotorProvider>(context, listen: false);
    final success = await provider.addMotor(newMotor);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Unit motor "${newMotor.name}" berhasil ditambahkan ke database!'),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : 'Gagal menambahkan unit motor.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Motor Baru'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepOrange.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.deepOrange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Menambahkan unit armada motor rental baru ke sistem database SQLite MotoRent Singaraja.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 1. Nama Motor
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Unit Motor *',
                  hintText: 'Misal: Honda PCX 160 RoadSync',
                  prefixIcon: Icon(Icons.two_wheeler),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama motor wajib diisi';
                  }
                  if (val.trim().length < 3) {
                    return 'Nama motor minimal 3 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // 2. Merk Motor & Tipe Motor Row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(
                        labelText: 'Merk / Brand *',
                        hintText: 'Honda, Yamaha, dll',
                        prefixIcon: Icon(Icons.branding_watermark),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Merk wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Motor *',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      items: _typeOptions.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedType = val;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 3. Kapasitas CC & Tarif Sewa Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _ccController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CC Mesin *',
                        hintText: '160',
                        prefixIcon: Icon(Icons.speed),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'CC wajib diisi';
                        }
                        final parsed = int.tryParse(val.trim());
                        if (parsed == null || parsed <= 0) {
                          return 'CC tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Tarif / Hari (Rp) *',
                        hintText: '90000',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Tarif wajib diisi';
                        }
                        final parsed = int.tryParse(
                            val.replaceAll('.', '').trim());
                        if (parsed == null || parsed <= 0) {
                          return 'Harus angka valid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 4. Transmisi Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedTransmission,
                decoration: const InputDecoration(
                  labelText: 'Jenis Transmisi *',
                  prefixIcon: Icon(Icons.settings),
                  border: OutlineInputBorder(),
                ),
                items: _transmissionOptions.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedTransmission = val;
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              // 5. URL Gambar
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar Motor (Opsional)',
                  hintText: 'https://images.unsplash.com/...',
                  prefixIcon: Icon(Icons.image_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              // 6. Rating Bintang
              const Text(
                'Rating Unit Motor',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  RatingStarsWidget(
                    rating: _rating,
                    size: 26,
                    isInteractive: true,
                    onRatingChanged: (newRating) {
                      setState(() {
                        _rating = newRating;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$_rating / 5.0',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 7. Status Ketersediaan Switch
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Status Ketersediaan Unit',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Text(
                    _isAvailable
                        ? 'Unit siap dan dapat disewa oleh pelanggan'
                        : 'Unit sedang dalam perawatan / tidak tersedia',
                    style: TextStyle(
                        fontSize: 12,
                        color: _isAvailable ? Colors.green : Colors.red),
                  ),
                  value: _isAvailable,
                  activeThumbColor: Colors.deepOrange,
                  onChanged: (val) {
                    setState(() {
                      _isAvailable = val;
                    });
                  },
                ),
              ),

              const SizedBox(height: 14),

              // 8. Fasilitas Termasuk
              TextFormField(
                controller: _facilitiesController,
                decoration: const InputDecoration(
                  labelText: 'Fasilitas Sewa (Pisahkan dengan koma) *',
                  hintText: '2 Helm SNI, Jas Hujan, Holder HP, Kunci Gembok',
                  prefixIcon: Icon(Icons.checklist),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Fasilitas sewa wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // 9. Deskripsi Unit
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi & Kondisi Unit Motor *',
                  hintText:
                      'Tuliskan keunggulan, kondisi mesin, atau spesifikasi unit motor...',
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  if (val.trim().length < 10) {
                    return 'Deskripsi minimal 10 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // 10. Tombol Submit
              SizedBox(
                width: double.infinity,
                child: CustomButtonWidget(
                  label: 'Simpan Motor ke Database SQLite',
                  icon: Icons.save,
                  isLoading: _isLoading,
                  color: Colors.deepOrange,
                  onPressed: _submitForm,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
