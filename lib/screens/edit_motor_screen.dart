import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/motor_model.dart';
import '../providers/motor_provider.dart';
import '../widgets/rating_stars_widget.dart';
import '../widgets/custom_button_widget.dart';

class EditMotorScreen extends StatefulWidget {
  final MotorModel motor;

  const EditMotorScreen({
    super.key,
    required this.motor,
  });

  @override
  State<EditMotorScreen> createState() => _EditMotorScreenState();
}

class _EditMotorScreenState extends State<EditMotorScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _ccController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _facilitiesController;
  late TextEditingController _descriptionController;

  late String _selectedType;
  late String _selectedTransmission;
  late bool _isAvailable;
  late double _rating;
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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.motor.name);
    _brandController = TextEditingController(text: widget.motor.brand);
    _ccController = TextEditingController(text: widget.motor.cc.toString());
    _priceController =
        TextEditingController(text: widget.motor.pricePerDay.toString());
    _imageUrlController = TextEditingController(text: widget.motor.imageUrl);
    _facilitiesController =
        TextEditingController(text: widget.motor.facilities.join(', '));
    _descriptionController =
        TextEditingController(text: widget.motor.description);

    _selectedType = _typeOptions.contains(widget.motor.type)
        ? widget.motor.type
        : 'Matic';
    _selectedTransmission =
        _transmissionOptions.contains(widget.motor.transmission)
            ? widget.motor.transmission
            : 'Otomatis';
    _isAvailable = widget.motor.isAvailable;
    _rating = widget.motor.rating;
  }

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

  Future<void> _updateForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final cc = int.tryParse(_ccController.text.trim()) ?? widget.motor.cc;
    final price =
        int.tryParse(_priceController.text.replaceAll('.', '').trim()) ??
            widget.motor.pricePerDay;

    String imageUrl = _imageUrlController.text.trim();
    if (imageUrl.isEmpty) {
      imageUrl = widget.motor.imageUrl;
    }

    final facilities = _facilitiesController.text
        .split(',')
        .map((f) => f.trim())
        .where((f) => f.isNotEmpty)
        .toList();

    final updatedMotor = widget.motor.copyWith(
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
          : widget.motor.facilities,
    );

    final provider = Provider.of<MotorProvider>(context, listen: false);
    final success = await provider.updateMotor(updatedMotor);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Data unit motor "${updatedMotor.name}" berhasil diperbarui!'),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : 'Gagal memperbarui unit motor.'),
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
        title: const Text('Edit Unit Motor (Update)'),
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
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_note, color: Colors.amber.shade900),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Mengedit kolom data Motor ID #${widget.motor.id} • ${widget.motor.name}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown.shade800,
                          fontWeight: FontWeight.w600,
                        ),
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
                  labelText: 'URL Gambar Motor *',
                  prefixIcon: Icon(Icons.image_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'URL gambar wajib diisi';
                  }
                  return null;
                },
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

              // 10. Tombol Simpan Perubahan
              SizedBox(
                width: double.infinity,
                child: CustomButtonWidget(
                  label: 'Simpan Perubahan Unit Motor',
                  icon: Icons.update,
                  isLoading: _isLoading,
                  color: Colors.deepOrange,
                  onPressed: _updateForm,
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
